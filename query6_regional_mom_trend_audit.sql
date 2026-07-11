/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
QUERY 6: Global Operations & MoM Trend Audit (JOIN & Time-Series Integration)
DESCRIPTION: Synthesizes a strategic region-mapping lookup via UNION ALL for 
             all 10 Pareto-isolated loss countries, truncates timelines via 
             DATE_TRUNC, and utilizes LAG() with a fixed temporal gap-check 
             to compute non-distorted Month-over-Month profit velocity.
===============================================================================
*/

WITH regional_lookup AS (
  -- Full 10-country cross-sectional mapping matrix for dashboard visualization
  SELECT 'Nigeria' AS country, 'Sub-Saharan Africa' AS region_group UNION ALL
  SELECT 'Turkey' AS country, 'EMEA' AS region_group UNION ALL
  SELECT 'South Korea' AS country, 'APAC' AS region_group UNION ALL
  SELECT 'Netherlands' AS country, 'EMEA' AS region_group UNION ALL
  SELECT 'Panama' AS country, 'LATAM' AS region_group UNION ALL
  SELECT 'Honduras' AS country, 'LATAM' AS region_group UNION ALL
  SELECT 'Argentina' AS country, 'LATAM' AS region_group UNION ALL
  SELECT 'Philippines' AS country, 'APAC' AS region_group UNION ALL
  SELECT 'Pakistan' AS country, 'APAC' AS region_group UNION ALL
  SELECT 'Sweden' AS country, 'EMEA' AS region_group
),

monthly_regional_metrics AS (
  SELECT
    geo.region_group,
    DATE_TRUNC(clean.order_date, MONTH) AS operation_month,
    ROUND(SUM(clean.profit), 2) AS current_month_profit
  FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean` clean
  INNER JOIN regional_lookup geo 
    ON clean.country = geo.country
  GROUP BY geo.region_group, operation_month
)

SELECT
  region_group,
  operation_month,
  current_month_profit,
  -- Prior month remains NULL at time-series inception (Compliance with IML-SQL-06)
  LAG(current_month_profit) OVER(
    PARTITION BY region_group 
    ORDER BY operation_month ASC
  ) AS prior_month_profit,
  
  -- Temporal lock measures the exact monthly gap between rows
  DATE_DIFF(
    operation_month, 
    LAG(operation_month) OVER(PARTITION BY region_group ORDER BY operation_month ASC), 
    MONTH
  ) AS months_gap,

  -- Calculation safety guard against index shifts during historical data gaps
  CASE 
    WHEN DATE_DIFF(operation_month, LAG(operation_month) OVER(PARTITION BY region_group ORDER BY operation_month ASC), MONTH) = 1 
    THEN ROUND(current_month_profit - LAG(current_month_profit) OVER(PARTITION BY region_group ORDER BY operation_month ASC), 2)
    ELSE NULL 
  END AS true_mom_profit_velocity

FROM monthly_regional_metrics
ORDER BY region_group, operation_month ASC;
