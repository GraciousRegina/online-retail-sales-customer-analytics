-- Retail Sales & Customer Analytics | SQLite
-- Source: cleaned CSV produced by the Python notebook.
-- Grain: one row per purchased product line.
-- TotalRevenue is a LINE amount. Never SUM it after joining to customer-level aggregates.

-- 1. Executive KPIs
SELECT COUNT(*) AS transaction_lines,
       ROUND(SUM(TotalRevenue), 2) AS revenue_gbp,
       COUNT(DISTINCT InvoiceNo) AS distinct_orders,
       COUNT(DISTINCT CustomerID) AS identified_customers,
       ROUND(SUM(TotalRevenue) / NULLIF(COUNT(DISTINCT InvoiceNo), 0), 2) AS avg_order_value_gbp
FROM retail;

-- 2. Monthly revenue and order volumes
SELECT MonthYear AS month,
       ROUND(SUM(TotalRevenue), 2) AS revenue_gbp,
       COUNT(DISTINCT InvoiceNo) AS orders,
       SUM(Quantity) AS units_sold
FROM retail
GROUP BY MonthYear
ORDER BY MonthYear;

-- 3. Top 10 real products by revenue (excluding service/postage entries)
SELECT Description AS product,
       ROUND(SUM(TotalRevenue), 2) AS revenue_gbp,
       SUM(Quantity) AS units_sold
FROM retail
WHERE Description IS NOT NULL
  AND TRIM(Description) <> ''
  AND UPPER(TRIM(Description)) NOT IN ('POSTAGE', 'DOTCOM POSTAGE', 'MANUAL')
GROUP BY Description
ORDER BY SUM(TotalRevenue) DESC
LIMIT 10;

-- 4. Top 10 countries by revenue
SELECT Country AS country,
       ROUND(SUM(TotalRevenue), 2) AS revenue_gbp,
       COUNT(DISTINCT InvoiceNo) AS orders
FROM retail
GROUP BY Country
ORDER BY SUM(TotalRevenue) DESC
LIMIT 10;

-- 5. Revenue by customer segment
-- Counts customers only when a CustomerID is available.
SELECT Segment AS customer_segment,
       ROUND(SUM(TotalRevenue), 2) AS revenue_gbp,
       COUNT(DISTINCT CustomerID) AS identified_customers,
       COUNT(DISTINCT InvoiceNo) AS orders
FROM retail
GROUP BY Segment
ORDER BY SUM(TotalRevenue) DESC;

-- 6. Highest-spending identified customers
SELECT CAST(CustomerID AS TEXT) AS customer_id,
       ROUND(SUM(TotalRevenue), 2) AS lifetime_revenue_gbp,
       COUNT(DISTINCT InvoiceNo) AS orders,
       ROUND(SUM(TotalRevenue) / NULLIF(COUNT(DISTINCT InvoiceNo), 0), 2) AS avg_order_value_gbp
FROM retail
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY SUM(TotalRevenue) DESC
LIMIT 10;

-- 7. Segment revenue share using a window function
WITH segment_sales AS (
  SELECT Segment, SUM(TotalRevenue) AS revenue
  FROM retail
  GROUP BY Segment
)
SELECT Segment,
       ROUND(revenue, 2) AS revenue_gbp,
       ROUND(100.0 * revenue / NULLIF(SUM(revenue) OVER (), 0), 2) AS revenue_share_pct
FROM segment_sales
ORDER BY revenue DESC;
