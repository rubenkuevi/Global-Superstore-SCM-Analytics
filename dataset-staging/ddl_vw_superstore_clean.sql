/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
LAYER: Dataset Staging / Analytical Layer Transformation
SCRIPT: DDL for View Creation (vw_superstore_clean)
DESCRIPTION: Replicates the production analytical schema across 28 validated fields.
             Integrates calculated logistics metrics (lead_time), advanced 
             commercial vectors (full_price_sales, profit_margin), and the 
             strategic operational risk indicator (triage_flag).
             Utilizes SAFE_CAST on all vulnerable metrics and date-vectors 
             to prevent runtime pipeline erosion from malformed source data.
===============================================================================
*/

CREATE OR REPLACE VIEW `global-supply-project.gym_supply_portfolio.vw_superstore_clean` AS
SELECT
  -- Relational Anchors & Core IDs
  SAFE_CAST(order_id AS STRING) AS order_id,
  SAFE_CAST(customer_id AS STRING) AS customer_id,
  SAFE_CAST(customer_name AS STRING) AS customer_name,
  SAFE_CAST(product_id AS STRING) AS product_id,
  SAFE_CAST(product_name AS STRING) AS product_name,

  -- Geographic & Market Hierarchy (Preserving Production Capitalization)
  SAFE_CAST(Segment AS STRING) AS Segment,
  SAFE_CAST(City AS STRING) AS City,
  SAFE_CAST(State AS STRING) AS State,
  SAFE_CAST(Country AS STRING) AS Country,
  SAFE_CAST(Market AS STRING) AS Market,
  SAFE_CAST(Region AS STRING) AS Region,
  
  -- Logistic Attributes
  SAFE_CAST(sub_category AS STRING) AS sub_category,
  SAFE_CAST(ship_mode AS STRING) AS ship_mode,
  SAFE_CAST(order_priority AS STRING) AS order_priority,

  -- Temporal Dimensions (CORRECTED: Safe-Casting to protect against format corruption)
  SAFE_CAST(order_date AS DATE) AS order_date,
  SAFE_CAST(ship_date AS DATE) AS ship_date,
  SAFE_CAST(quantity AS INT64) AS quantity,
  SAFE_CAST(year AS INT64) AS year,
  SAFE_CAST(weeknum AS INT64) AS weeknum,
  
  -- Engineered SCM Lead-Time
  SAFE_CAST(lead_time AS INT64) AS lead_time,

  -- Financial Indicators & Engineered Commercial Metrics (FLOAT64 Precision)
  SAFE_CAST(cogs AS FLOAT64) AS cogs,
  SAFE_CAST(profit AS FLOAT64) AS profit,
  SAFE_CAST(shipping_cost AS FLOAT64) AS shipping_cost,
  SAFE_CAST(sales AS FLOAT64) AS sales,
  SAFE_CAST(full_price_sales AS FLOAT64) AS full_price_sales,
  SAFE_CAST(discount AS FLOAT64) AS discount,
  SAFE_CAST(profit_margin AS FLOAT64) AS profit_margin,

  -- Risk Management Risk-Matrix Component
  SAFE_CAST(triage_flag AS STRING) AS triage_flag

FROM 
  `global-supply-project.gym_supply_portfolio.superstore_raw`;
