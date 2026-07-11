/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
QUERY 5: Logistics Efficiency & Lead-Time Deviation Matrix
DESCRIPTION: Computes average transit durations using the pre-engineered lead_time 
             column and measures the operational "Logistics Drag" of distressed 
             markets both in absolute days and relative percentage variance 
             against the global baseline.
===============================================================================
*/

WITH country_logistics AS (
  SELECT
    country,
    COUNT(DISTINCT order_id) AS volume_orders,
    ROUND(AVG(lead_time), 2) AS avg_country_lead_time_days
  FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean`
  GROUP BY country
),

global_logistics_baseline AS (
  SELECT
    ROUND(AVG(lead_time), 2) AS global_avg_lead_time_days
  FROM `global-supply-project.gym_supply_portfolio.vw_superstore_clean`
)

SELECT
  cl.country,
  cl.volume_orders,
  cl.avg_country_lead_time_days,
  gb.global_avg_lead_time_days AS global_baseline_days,
  -- 1. Absolute deviation in days
  ROUND(cl.avg_country_lead_time_days - gb.global_avg_lead_time_days, 2) AS logistics_drag_days,
  -- 2. Relative percentage variance for the C-suite dashboard
  ROUND(((cl.avg_country_lead_time_days - gb.global_avg_lead_time_days) / gb.global_avg_lead_time_days) * 100, 2) AS deviation_pct
FROM country_logistics cl
CROSS JOIN global_logistics_baseline gb
WHERE cl.country IN ('Philippines', 'Turkey', 'Honduras', 'Netherlands', 'Pakistan', 'Argentina', 'Nigeria', 'Panama', 'South Korea', 'Sweden')
ORDER BY logistics_drag_days DESC;
