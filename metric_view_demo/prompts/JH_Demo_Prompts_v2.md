-- ============================================================
-- Metric View Sample Queries V1
-- Tests for: catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- ============================================================

-- Query 1: Basic Order Metrics by Month
SELECT 
  `Order Month`,
  MEASURE(`Order Count`) AS order_count,
  MEASURE(`Total Revenue`) AS total_revenue,
  MEASURE(`Average Order Value`) AS avg_order_value
FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
GROUP BY `Order Month`
ORDER BY `Order Month`
LIMIT 20;

-- Query 2: Order Status Distribution
-- SELECT 
--   `Order Status`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Revenue`) AS total_revenue,
--   MEASURE(`Open Order Revenue`) AS open_revenue,
--   MEASURE(`Fulfilled Order Revenue`) AS fulfilled_revenue
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Order Status`
-- ORDER BY total_revenue DESC;

-- Query 3: Revenue by Region (Tests customer->nation->region join)
-- SELECT 
--   `Region Name`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Revenue`) AS total_revenue,
--   MEASURE(`Unique Customer Count`) AS unique_customers,
--   MEASURE(`Revenue per Customer`) AS revenue_per_customer
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Region Name`
-- ORDER BY total_revenue DESC;

-- Query 4: Revenue by Customer Market Segment (Tests customer join)
-- SELECT 
--   `Customer Market Segment`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Revenue`) AS total_revenue,
--   MEASURE(`Average Order Value`) AS avg_order_value,
--   MEASURE(`Unique Customer Count`) AS unique_customers
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Customer Market Segment`
-- ORDER BY total_revenue DESC;

-- Query 5: Top 10 Customers by Revenue (Tests customer join)
-- SELECT 
--   `Customer Name`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Revenue`) AS total_revenue,
--   MEASURE(`Average Order Value`) AS avg_order_value
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Customer Name`
-- ORDER BY total_revenue DESC
-- LIMIT 10;

-- Query 6: Ship Mode Analysis (Tests lineitem join)
-- SELECT 
--   `Ship Mode`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Quantity`) AS total_qty,
--   MEASURE(`Total Extended Price`) AS extended_price,
--   MEASURE(`Average Discount`) AS avg_discount
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Ship Mode`
-- ORDER BY extended_price DESC;

-- Query 7: Region and Order Status Cross-Tab
-- SELECT 
--   `Region Name`,
--   `Order Status`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Revenue`) AS total_revenue
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Region Name`, `Order Status`
-- ORDER BY `Region Name`, `Order Status`;

-- Query 8: Nation-Level Revenue (Tests customer->nation join)
-- SELECT 
--   `Nation Name`,
--   `Region Name`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Revenue`) AS total_revenue,
--   MEASURE(`Revenue per Customer`) AS revenue_per_customer
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Nation Name`, `Region Name`
-- ORDER BY total_revenue DESC
-- LIMIT 15;

-- Query 9: Fulfillment Trends by Month (Tests lineitem join)
-- SELECT 
--   `Order Month`,
--   MEASURE(`Avg Fulfillment Days`) AS avg_fulfillment_days,
--   MEASURE(`Total Quantity`) AS total_qty,
--   MEASURE(`Order Count`) AS order_count
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Order Month`
-- ORDER BY `Order Month`
-- LIMIT 20;

-- Query 10: Return Flag Analysis (Tests lineitem join)
-- SELECT 
--   `Return Flag`,
--   `Line Status`,
--   MEASURE(`Order Count`) AS order_count,
--   MEASURE(`Total Quantity`) AS total_qty,
--   MEASURE(`Total Extended Price`) AS extended_price,
--   MEASURE(`Average Discount`) AS avg_discount
-- FROM catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view
-- GROUP BY `Return Flag`, `Line Status`
-- ORDER BY `Return Flag`, `Line Status`;