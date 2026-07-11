/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
QUERY 1: High-Risk Market Isolation (The Nigeria Margin Collapse)
DESCRIPTION: Filters and aggregates transaction data to isolate markets where 
             the profit margin dropped below -100%. Identifies system-wide 
             pricing vulnerabilities for the executive board.
===============================================================================
*/

SELECT
  country,
  COUNT(DISTINCT order_id) AS total_orders,
  ROUND(SUM(sales), 2) AS total_sales_usd,
  ROUND(SUM(profit), 2) AS total_profit_usd,
  ROUND((SUM(profit) / SUM(sales)) * 100, 2) AS aggregate_profit_margin_pct
FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean`
GROUP BY country
HAVING aggregate_profit_margin_pct < -100
ORDER BY total_profit_usd ASC;
