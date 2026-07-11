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
