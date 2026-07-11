/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
QUERY 3: Discount Band Elasticity Matrix (Dynamic Pareto Integration)
DESCRIPTION: Multi-dimensional revenue analysis using conditional aggregation. 
             Segments total sales into strategic discount tiers to map pricing 
             behavior and verify flat-rate contract breaches across the top 10 
             Pareto loss markets without static hardcoding.
===============================================================================
*/

WITH top_10_loss_countries AS (
  -- Dynamischer Filter: Holt die exakten 10 Verlustführer aus Query 2
  SELECT country
  FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean`
  GROUP BY country
  HAVING SUM(profit) < 0
  ORDER BY SUM(profit) ASC
  LIMIT 10
),

market_discounts AS (
  SELECT
    country,
    ROUND(SUM(sales), 2) AS total_sales,
    -- Bedingte Aggregation für die strategischen Volumenbänder
    ROUND(SUM(CASE WHEN discount = 0 THEN sales ELSE 0 END), 2) AS zero_discount_sales,
    ROUND(SUM(CASE WHEN discount > 0 AND discount <= 0.20 THEN sales ELSE 0 END), 2) AS core_promo_sales,
    ROUND(SUM(CASE WHEN discount > 0.20 AND discount <= 0.50 THEN sales ELSE 0 END), 2) AS high_discount_sales,
    ROUND(SUM(CASE WHEN discount > 0.50 THEN sales ELSE 0 END), 2) AS toxic_flatrate_sales
  FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean`
  -- Dynamische Schnittmenge mit dem Pareto-Register
  WHERE country IN (SELECT country FROM top_10_loss_countries)
  GROUP BY country
)

SELECT
  country,
  total_sales,
  -- Absolute Dollar-Bänder und Berechnung der relativen C-Suite-Prozentanteile
  zero_discount_sales,
  ROUND((zero_discount_sales / total_sales) * 100, 2) AS zero_discount_share_pct,
  toxic_flatrate_sales,
  ROUND((toxic_flatrate_sales / total_sales) * 100, 2) AS toxic_flatrate_share_pct
FROM market_discounts
ORDER BY total_sales DESC;
