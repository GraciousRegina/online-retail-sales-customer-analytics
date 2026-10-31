# Online Retail Sales & Customer Analytics

An end-to-end retail analytics portfolio project combining **Python, Pandas, SQL (SQLite), customer RFM segmentation, and Tableau** to examine sales performance, customer value, product demand, and geographic revenue patterns.

**[Explore the interactive Tableau dashboard](https://public.tableau.com/app/profile/gracious.zigara/viz/OnlineRetailSalesCustomerAnalyticsDashboard/Dashboard1)**

![Online Retail Sales & Customer Analytics Dashboard](Dashboard%201.png)

## Project overview

This analysis uses a cleaned Online Retail transaction dataset to answer practical business questions: Which customers and segments drive revenue? Which products and countries contribute most? How does sales activity change over time? What retention and merchandising actions could follow from these patterns?

## Tools and workflow

- **Python / Pandas / NumPy:** data cleaning, feature engineering, revenue KPIs, and exploratory analysis
- **RFM segmentation:** recency, frequency, and monetary customer classification
- **Matplotlib / Seaborn / Plotly / ipywidgets:** exploratory and interactive visualization
- **SQLite / SQL:** executive KPIs, monthly sales, product and country ranking, customer segments, a CTE and a window-function revenue share calculation
- **Tableau Public:** dashboard displaying revenue, orders, customers, monthly revenue, top products, country revenue, and segment revenue

## Key findings

| Metric | SQL result |
|---|---:|
| Cleaned transaction lines | 524,878 |
| Revenue | £10,642,110.80 |
| Distinct identified customers | 4,338 |
| Distinct orders (SQL) | 19,960 |
| Average order value (SQL) | £533.17 |

- **Champions** account for **£5.73M**, or **53.80%** of revenue.
- **United Kingdom** accounts for approximately **£9.00M** in revenue, the largest geographic contribution.
- **REGENCY CAKESTAND 3 TIER** leads the product revenue ranking with **£174,156.54**.
- Revenue associated with **Unidentified Customer** is approximately **£1.75M** (16.49%), which limits customer-level attribution.

### Metric reconciliation note

The published Tableau screenshot displays **19,959 total orders**, whereas the SQL query (`COUNT(DISTINCT InvoiceNo)`) returns **19,960**. This one-order discrepancy has **not yet been reconciled**; it may reflect a filter, calculation, or data-version difference. Revenue (£10.64M) and distinct customers (4,338) agree at the displayed precision. Do not treat the order counts as identical until the dashboard and SQL logic are compared.

## Business recommendations

1. **Protect high-value customers:** Develop retention and loyalty offers for Champions, who contribute more than half of total revenue.
2. **Win back at-risk shoppers:** Test segmented reactivation campaigns for At Risk and Hibernating customers, then measure incremental repeat purchases.
3. **Strengthen customer identification:** Investigate missing customer identifiers and improve capture processes so more sales can be attributed to customer cohorts.
4. **Prioritize high-performing products:** Use top-product revenue and units sold to inform replenishment planning, while validating margins and seasonality before changing inventory levels.
5. **Evaluate international growth:** Assess delivery economics and demand in the Netherlands, Ireland, Germany, and France before expanding beyond the UK-dominant revenue base.

These are **data-informed proposals**, not measured intervention outcomes.

## Repository structure

```text
notebooks/
  retail_sales_customer_analysis.ipynb   # Cleaning, EDA, RFM, interactive charts, recommendations
sql/
  retail_analysis.sql            # Seven SQL analyses, including CTE/window function
results/
  query_01.csv ... query_05.csv, query_07.csv  # Aggregate SQL outputs
images/
  tableau_dashboard.png
run_sql_analysis.py              # SQLite runner for a cleaned CSV
README.md
.gitignore
```

`query_06.csv` is intentionally omitted because it contains customer-level identifiers.

## How to reproduce

1. Open `notebooks/retail_sales_customer_analysis.ipynb` in Google Colab and upload the source `OnlineRetail.csv` into the runtime. Run the notebook in order; the original notebook contains Colab-specific export steps.
2. Export the cleaned Tableau-ready CSV with customer IDs from the notebook (`Retail_Tableau_Dashboard_Data_With_CustomerID.csv`). The raw source and customer-level CSV are **not included in this public repository**.
3. Install `pandas` in a Python environment, then run:

```bash
python run_sql_analysis.py "path/to/Retail_Tableau_Dashboard_Data_With_CustomerID.csv"
```

4. The script loads the cleaned CSV into an in-memory SQLite database and writes non-customer-level query results to `results/`. The customer-level query runs but its results are not exported.
5. View the interactive Tableau dashboard using the link above.

**Data/privacy:** This repository intentionally excludes raw and customer-level transaction files. The notebook is distributed without execution outputs to avoid publishing cached records. Verify the original dataset's redistribution terms before sharing it elsewhere.

## Limitations

- Observational sales analysis cannot establish causal effects of proposed interventions.
- Missing customer IDs limit full-customer segmentation coverage.
- The published dashboard and SQL order counts differ by one and require reconciliation.
- The dashboard's monthly chart should be interpreted in light of its Tableau date aggregation and filters; it is not necessarily a separate year-by-year time series.
