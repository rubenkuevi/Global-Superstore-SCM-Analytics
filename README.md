# Global Superstore SCM Analytics Portfolio

## Executive Summary

> "This project isolates the core commercial drivers behind a 79.27% global margin leakage across 10 distressed markets — proving the deficit is driven entirely by undifferentiated flat-rate discounting, not by logistics failures."

By architecting a robust ELT pipeline in Google BigQuery, this portfolio project deconstructs a severe margin collapse within a multi-regional retail network (51,291 transactions). While the operational logistics network performs efficiently, unhedged commercial sales incentives completely liquidated corporate profits across 10 core distressed countries.

### Key Business Insights:
* **The Pareto Deficit Concentration:** Just 10 countries account for exactly **79.27% of global net losses**, spearheaded by Turkey, the Philippines, and Nigeria.
* **Logistics Performance Audit:** Operational lead-time analysis confirms that distressed markets operate at or below the global transit baseline. The root cause of the deficit is 0% operational drag, but 100% commercial leakage.
* **Q4 Margin Contraction:** Time-series velocity mapping unmasks a systematic year-end profitability drop in Sub-Saharan Africa, pointing toward aggressive year-end volume-push strategies at the expense of margin health.

---

## 3-Tier Architecture Framework

To ensure financial safety and data scalability, the project was executed in three sequential phases:

To ensure financial safety and data scalability, the project was executed in three sequential phases:

```text
+---------------------------------------+
|  Phase 1: Agile Prototyping (Excel)  | --> Validated business rules & isolated Nigeria anomaly via Pivot Tables.
+---------------------------------------+
                    |
+---------------------------------------+
|   Phase 2: Production Scaling (SQL)   | --> Engineered an enterprise ELT pipeline with 6 analytical queries in BigQuery.
+---------------------------------------+
                    |
+---------------------------------------+
|  Phase 3: Executive BI (Upcoming)     | --> Designing an interactive Power BI C-Suite Performance Dashboard.
+---------------------------------------+


---

## Repository Structure & Query Map

The analytical engine behind this portfolio consists of 6 production-ready SQL scripts:

| File Name | Analytical Scope | Key Engineering Highlights |
| :--- | :--- | :--- |
| `query1_nigeria_margin_collapse.sql` | High-Risk Market Isolation | Out-of-bounds filter isolates margins dropping below -100%. |
| `query2_pareto_loss_filter.sql` | Global Deficit Concentration | Window functions (`SUM() OVER`) & Cross Joins to calculate the 79.27% baseline. |
| `query3_discount_elasticity_matrix.sql` | Discount Band Elasticity | Multi-dimensional conditional aggregation (`CASE WHEN`) mapping revenue tiers. |
| `query4_staging_ingestion_audit.sql` | Pipeline Debugging & Auditing | 3-way composite key check (`Order_ID` + `Sub_Category` + `Product_ID`) blocking m:n row explosion. |
| `query5_logistics_efficiency_check.sql` | Operational Drag Analysis | Direct temporal calculation (`DATE_DIFF`) comparing regional lead times against global averages. |
| `query6_regional_mom_trend_audit.sql` | Time-Series Profit Velocity | Relational `INNER JOIN` lookup, `DATE_TRUNC`, and `LAG()` with an automatic index-gap safety lock. |

---

## Core SCM Anomalies (The Archetypes)

The data reveals three distinct corporate vulnerability patterns across the portfolio:

### A. Total Commercial Inelasticity (Turkey & Nigeria)
* **The Metric:** Dominant Toxic Flat-Rate Revenue Share.
* **The Reality:** The sales distribution in these markets is completely decoupled from product manufacturing margins (COGS). Volume was pushed by applying standard flat-discounts exceeding 50% (historically locked at 70% flat for Nigeria and 60% flat for Turkey) across entire product cohorts.

### B. Hidden Contractual Erosion (The Netherlands)
* **The Metric:** Rigid 50.0% Discount Blindness.
* **The Reality:** A seemingly moderate aggregate country discount masks a rigid corporate contract error. Across high-volume sub-categories (such as Bookcases), discounts were locked at exactly 50.0%, creating a structural margin bleed despite flawless freight execution.

### C. Toxic Promotion Dependency (LATAM Region)
* **The Metric:** Near-Zero Full-Price Revenue Share.
* **The Reality:** In markets like Honduras, Panama, and Argentina, the baseline full-price retail engine is non-existent. Overwhelming parts of the sales volume depend heavily on continuous promotion bands, making the entire regional sales model a financial liability.

---

## Data Source & Replication Note
*The SQL scripts reference a production-scaled Cloud instance (`global-supply-project.gym_supply_portfolio.vw_superstore_clean`). The baseline schema is built upon the standardized Global Superstore Dataset.*
