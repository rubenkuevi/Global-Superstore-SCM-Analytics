/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
QUERY 2: Dynamic Pareto Loss Filter (Global Deficit Concentration)
DESCRIPTION: Calculates the cumulative financial deficit across global markets.
             Utilizes window functions and a cross join to isolate the top 10 
             distressed countries responsible for exactly 79.27% of total losses.
===============================================================================
*/

WITH country_profitability AS (
  -- Step 1: Isolate all net loss markets
  SELECT
    country,
    ROUND(SUM(profit), 2) AS total_country_profit
  FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean`
  GROUP BY country
  HAVING total_country_profit < 0
),

global_total_loss AS (
  -- Step 2: Calculate total global deficit across all net loss markets
  SELECT
    ROUND(SUM(total_country_profit), 2) AS global_deficit
  FROM country_profitability
)

SELECT
  cp.country,
  cp.total_country_profit,
  -- Analytical window function calculates the running total of global losses
  ROUND(
    SUM(cp.total_country_profit) OVER (ORDER BY cp.total_country_profit ASC), 
    2
  ) AS cumulative_loss,
  -- Cross join provides the global baseline for relative percentage calculation
  ROUND(
    (SUM(cp.total_country_profit) OVER (ORDER BY cp.total_country_profit ASC) / gtl.global_deficit) * 100, 
    2
  ) AS cumulative_loss_pct
FROM country_profitability cp
CROSS JOIN global_total_loss gtl
ORDER BY cp.total_country_profit ASC
LIMIT 10;
