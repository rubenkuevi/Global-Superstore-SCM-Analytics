/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
LAYER: Dataset Staging / Analytical Layer Transformation
SCRIPT: DDL for View Creation (vw_superstore_clean)
DESCRIPTION: Replicates production analytical schema across 28 validated fields.
             Integrates calculated logistics metrics (lead_time), advanced 
             commercial vectors (full_price_sales, profit_margin), and the 
             strategic operational risk indicator (triage_flag).
             Utilizes advanced string-cleaning, TRIM, and CASE logic to prevent 
             pipeline erosion and NULL degradation from localized formats.
             Date fields are parsed explicitly via PARSE_DATE (DD.MM.YYYY format)
             to prevent silent NULL degradation from ambiguous SAFE_CAST behavior.
===============================================================================
*/

CREATE OR REPLACE VIEW `global-supply-project.gym_supply_portfolio.vw_superstore_clean` AS
SELECT
  -- Relational Anchors & Core IDs
  SAFE_CAST(Order_ID AS STRING) AS order_id,
  SAFE_CAST(Customer_ID AS STRING) AS customer_id,
  SAFE_CAST(Customer_Name AS STRING) AS customer_name,
  SAFE_CAST(Product_ID AS STRING) AS product_id,
  SAFE_CAST(Product_Name AS STRING) AS product_name,

  -- Geographic & Market Hierarchy (Preserving Production Capitalization)
  SAFE_CAST(Category AS STRING) AS Category,
  SAFE_CAST(Segment AS STRING) AS Segment,
  SAFE_CAST(City AS STRING) AS City,
  SAFE_CAST(State AS STRING) AS State,
  SAFE_CAST(Country AS STRING) AS Country,
  SAFE_CAST(Market AS STRING) AS Market,
  SAFE_CAST(Region AS STRING) AS Region,

  -- Logistic Attributes
  SAFE_CAST(Sub_Category AS STRING) AS sub_category,
  SAFE_CAST(Ship_Mode AS STRING) AS ship_mode,
  SAFE_CAST(Order_Priority AS STRING) AS order_priority,

  -- Temporal Dimensions (Explicit PARSE_DATE for DD.MM.YYYY source format —
  -- prevents silent NULL degradation that occurs with ambiguous SAFE_CAST)
  SAFE.PARSE_DATE('%d.%m.%Y', Order_Date) AS order_date,
  SAFE.PARSE_DATE('%d.%m.%Y', Ship_Date) AS ship_date,
  SAFE_CAST(Quantity AS INT64) AS quantity,
  SAFE_CAST(Year AS INT64) AS year,
  SAFE_CAST(weeknum AS INT64) AS weeknum,

  -- Engineered SCM Lead-Time
  SAFE_CAST(Lead_Time AS INT64) AS lead_time,

  -- Financial Indicators & Engineered Commercial Metrics (FLOAT64 Precision + Clean String Conversion)
  CASE 
    WHEN TRIM(COGS) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(COGS), r'[\$\s]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(COGS), r'[\$\s]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS cogs,

  CASE 
    WHEN TRIM(Profit) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(Profit), r'[\$\s]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(Profit), r'[\$\s]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS profit,

  CASE 
    WHEN TRIM(Shipping_Cost) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(Shipping_Cost), r'[\$\s]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(Shipping_Cost), r'[\$\s]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS shipping_cost,

  CASE 
    WHEN TRIM(Sales) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(Sales), r'[\$\s]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(Sales), r'[\$\s]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS sales,

  CASE 
    WHEN TRIM(Full_Price_Sales) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(Full_Price_Sales), r'[\$\s]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(Full_Price_Sales), r'[\$\s]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS full_price_sales,

  CASE 
    WHEN TRIM(Discount) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(Discount), r'[\$\s%]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(Discount), r'[\$\s%]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS discount,

  CASE 
    WHEN TRIM(Profit_Margin) IS NULL THEN NULL
    WHEN REGEXP_REPLACE(TRIM(Profit_Margin), r'[\$\s%]', '') IN ('', '-', '$-') THEN 0.0
    ELSE SAFE_CAST(REPLACE(REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(TRIM(Profit_Margin), r'[\$\s%]', ''), r'^\((.*)\)$', r'-\1'), '.', ''), ',', '.') AS FLOAT64)
  END AS profit_margin,

  -- Risk Management Risk-Matrix Component
  SAFE_CAST(Triage_Flag AS STRING) AS triage_flag

FROM 
  `global-supply-project.gym_supply_portfolio.superstore_raw`
WHERE Country != 'Country';
