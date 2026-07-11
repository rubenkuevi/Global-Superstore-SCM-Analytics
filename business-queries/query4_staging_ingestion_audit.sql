/*
===============================================================================
PROJECT: Global Superstore SCM Portfolio
QUERY 4: Data Warehouse Ingestion Audit (Pipeline Debugging)
DESCRIPTION: Investigates silent data degradation within the ELT pipeline by 
             joining the raw staging layer against the typed analytical layer. 
             Utilizes a 3-way primary key configuration to eliminate m:n row explosion.
===============================================================================
*/

SELECT 
  raw.Order_ID AS raw_order_id,
  raw.Sub_Category AS raw_sub_category,
  raw.COGS AS raw_cogs_string,
  clean.cogs AS clean_cogs_float64,
  raw.Profit AS raw_profit_string,
  clean.profit AS clean_profit_float64
FROM `global-supply-project.gym_supply_portfolio.superstore_raw` raw
LEFT JOIN `global-supply-project.gym_supply_portfolio.vw_superstore_clean` clean
  ON raw.Order_ID = clean.order_id 
  AND raw.Sub_Category = clean.sub_category
  AND raw.Product_ID = clean.product_id
WHERE raw.Country = 'South Korea' 
  AND raw.Sub_Category = 'Bookcases'
ORDER BY raw.Order_ID ASC;
