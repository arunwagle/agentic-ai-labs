# JH Metrics View Demo V2

## Table of contents

- [What is a Metric View?](#what-is-a-metric-view)
- [How to run this demo with Databricks Genie Code](#how-to-run-this-demo-with-databricks-genie-code)
- [Demo Assets Overview](#demo-assets-overview)
- [Asset Summary](#asset-summary)

---

## What is a Metric View?

A **Metric View** is a Databricks Unity Catalog feature that defines reusable, governed business metrics in a centralized, queryable format. It creates a **semantic layer** over your data, transforming raw tables into standardized, business-friendly metrics.

**Official documentation:** [Unity Catalog metric views](https://docs.databricks.com/aws/en/metric-views/) — overview, components (dimensions, measures, joins), access in Catalog Explorer, querying with `MEASURE()`, and consuming metric views in dashboards, Genie, and other tools.

### Key Concepts

| Concept | Description |
|---------|-------------|
| **Source** | The base table, view, or SQL query containing raw data |
| **Dimensions** | Categorical attributes used to segment or group metrics (e.g., region, product category, time period) |
| **Measures** | Aggregated values that produce the metrics (e.g., `SUM(revenue)`, `COUNT(orders)`) |
| **Joins** | Star and snowflake schema joins that enrich metrics with related dimension tables |
| **Composability** | The ability to build complex metrics by referencing simpler ones using `MEASURE()` |
| **Semantic Metadata** | Display names, formats, and synonyms that enhance BI tool integration and LLM accuracy |

### Why Use Metric Views?

- **Standardize metric definitions** across teams and tools to prevent inconsistencies
- **Handle complex measures** like ratios and distinct counts that cannot be safely re-aggregated in standard views
- **Enable flexible analysis** by supporting star and snowflake schemas with multi-level joins
- **Simplify the user experience** while maintaining SQL transparency and governance
- **Define metrics once, query flexibly** — measures are defined independently of dimensions, allowing aggregation across any dimension at runtime
- **Composability** — build layered, reusable logic by referencing previously defined dimensions and measures in new definitions

### How Metric Views Differ from Standard Views

Unlike standard views that lock in aggregations and dimensions at creation time, metric views **separate measure definitions from dimension groupings**. This allows you to define metrics once and query them flexibly across any dimension at runtime, while the query engine automatically generates the correct computation.

### YAML Syntax

Metric views are defined in YAML (version 1.1) and created using SQL DDL:

```sql
CREATE OR REPLACE VIEW my_metric_view
WITH METRICS
LANGUAGE YAML
AS $$
version: 1.1
source: catalog.schema.table
dimensions:
  - name: dim_name
    expr: "SQL expression"
measures:
  - name: measure_name
    expr: "aggregate SQL expression"
$$;
```

### Querying Metric Views

All measures must use the `MEASURE()` wrapper function:

```sql
SELECT dimension_col, MEASURE(measure_col) AS alias
FROM catalog.schema.metric_view
GROUP BY dimension_col
ORDER BY alias DESC;
```

For more details, see the [Databricks Metric Views Documentation](https://docs.databricks.com/aws/en/metric-views/).

---

## How to run this demo with Databricks Genie Code

This repository includes a **builder prompt** in [`prompts/JH_Demo_Prompts_v1.md`](prompts/JH_Demo_Prompts_v1.md) that instructs Genie Code to create the schema, metric view, SQL files, dashboards, Genie space, and this documentation. Follow the steps below in your Databricks workspace.

### Prerequisites

- **Genie Code** enabled for your workspace and your user (see [Use Genie Code](https://docs.databricks.com/aws/en/genie-code/use-genie-code)).
- **Unity Catalog** access to **`samples.tpch`** (e.g. `samples.tpch.orders`, `customer`, `lineitem`). The prompt assumes TPC-H sample data is available; adjust if your workspace uses a different catalog.
- Permission to create a schema and objects under the **catalog** named in the prompt (this demo uses `catalog_7w4dm4_eq04qz`—replace with **your** catalog if you fork the prompt).
- A SQL warehouse (or appropriate compute) available when Genie Code runs SQL.

### Steps

1. **Open Genie Code**  
   In the Databricks UI, open the **Genie Code** pane (upper-right of the workspace). See [Use Genie Code](https://docs.databricks.com/aws/en/genie-code/use-genie-code) for the full tour.

2. **Use Agent mode for multi-step work**  
   At the bottom of the Genie Code pane, switch to **Agent** mode. Agent mode is suited to **dashboard generation**, **pipeline-style tasks**, and **multi-step** workflows; Chat mode is better for short questions. Agent mode is not available in every surface—if Agent is unavailable where you are, open a context where it is supported (e.g. notebook or SQL editor per your workspace’s [Genie Code capabilities](https://docs.databricks.com/aws/en/genie-code/)).

3. **Reference the prompt with `@`**  
   In the Genie Code text box, type **`@`** and select **`JH_Demo_Prompts_v1`** (your workspace copy of [`prompts/JH_Demo_Prompts_v1.md`](prompts/JH_Demo_Prompts_v1.md)—import or sync this repo into the workspace first so the file appears in the `@` picker). That attaches the full builder prompt; you do not need to open the file elsewhere and copy-paste.  
   - If the attached file starts with `%md`, remove that line in the workspace copy—it is notebook magic, not part of the instruction block.  
   - Replace **`<your-username>`** with your workspace path segment (e.g. `arun.wagle@databricks.com`) everywhere folder paths use it.  
   - Align **folder names** with your workspace: the prompt references `/Workspace/Users/<your-username>/JH_Demo/`; this readme documents assets under `JH_Demo_v2`—edit the prompt file or say so in a follow-up so Genie targets the folder you want.

4. **Send**  
   Submit the message (with `@JH_Demo_Prompts_v1` attached). Add a short line if needed, e.g. “Execute all tasks in order.” Split by task (e.g. Task 1 only, then Task 2) if your session limits require it.

5. **Review and approve execution**  
   Genie Code may propose notebooks, SQL, or API calls (e.g. `dbutils.fs.rm`). **Review** suggested code before accepting. Use **Allow**, **Allow in this thread**, or **Always allow** according to your org’s policy when you are comfortable with the operations (deleting folders/schemas is destructive by design in this prompt’s prerequisites).

6. **Iterate on errors**  
   If dashboards show **Unknown column** or YAML errors, paste the error into a **follow-up** message and ask Genie to fix bindings or metric view definitions. Short iteration loops are normal.

7. **Optional: sample SQL file**  
   [`prompts/JH_Demo_Prompts_v2.md`](prompts/JH_Demo_Prompts_v2.md) contains **example `MEASURE()` queries** against `orders_metric_view` for validation; it is not the builder prompt. In Genie Code you can attach it with **`@JH_Demo_Prompts_v2`** (after it exists in the workspace) to run or adapt those queries.

### Tips

- Reference tables explicitly (e.g. `@samples.tpch.orders`) in follow-up prompts if Genie needs tighter context—see [Tips to improve Genie Code responses](https://docs.databricks.com/aws/en/genie-code/tips).
- Genie Code only accesses data and objects your identity is allowed to use in Unity Catalog.

---

## Demo Assets Overview

All assets are located in `/Workspace/Users/arun.wagle@databricks.com/JH_Demo_v2/`.

### 1. Schema & Metric View

| Asset | Details |
|-------|---------|
| **Catalog** | `catalog_7w4dm4_eq04qz` |
| **Schema** | `jh_metrics_view_demo_v1` |
| **Metric View** | `orders_metric_view` |
| **Source Table** | `samples.tpch.orders` |

#### Joins (Star + Snowflake Schema)

| Join Type | Path | Join Condition |
|-----------|------|----------------|
| Star | orders → customer | `o_custkey = c_custkey` |
| Snowflake | customer → nation | `c_nationkey = n_nationkey` |
| Snowflake | nation → region | `n_regionkey = r_regionkey` |
| Star | orders → lineitem | `o_orderkey = l_orderkey` |

#### Dimensions (10)

| Dimension | Source | Expression |
|-----------|--------|------------|
| `order_month` | orders | `DATE_TRUNC('MONTH', o_orderdate)` |
| `order_year` | orders | `DATE_TRUNC('YEAR', o_orderdate)` |
| `order_status` | orders | CASE on `o_orderstatus` (Open/Processing/Fulfilled) |
| `order_priority` | orders | `SPLIT(o_orderpriority, '-')[1]` |
| `customer_name` | customer join | `customer.c_name` |
| `market_segment` | customer join | `customer.c_mktsegment` |
| `nation_name` | snowflake join | `customer.nation.n_name` |
| `region_name` | snowflake join | `customer.nation.region.r_name` |
| `ship_mode` | lineitem join | `lineitem.l_shipmode` |
| `return_flag` | lineitem join | CASE on `lineitem.l_returnflag` |

#### Measures (12)

| Measure | Expression | Composable? |
|---------|------------|-------------|
| `order_count` | `COUNT(1)` | Base |
| `total_revenue` | `SUM(o_totalprice)` | Base |
| `avg_order_value` | `MEASURE(total_revenue) / MEASURE(order_count)` | Yes |
| `unique_customers` | `COUNT(DISTINCT o_custkey)` | Base |
| `revenue_per_customer` | `MEASURE(total_revenue) / MEASURE(unique_customers)` | Yes |
| `open_orders_revenue` | `SUM(o_totalprice) FILTER (WHERE o_orderstatus = 'O')` | Base |
| `fulfilled_orders_count` | `COUNT(1) FILTER (WHERE o_orderstatus = 'F')` | Base |
| `fulfillment_rate` | `MEASURE(fulfilled_orders_count) / MEASURE(order_count)` | Yes |
| `total_quantity` | `SUM(lineitem.l_quantity)` | Base (lineitem) |
| `total_extended_price` | `SUM(lineitem.l_extendedprice)` | Base (lineitem) |
| `avg_discount` | `AVG(lineitem.l_discount)` | Base (lineitem) |

### 2. SQL Sample Queries

| Asset | Details |
|-------|---------|
| **Name** | Metric View Sample Queries V1 |
| **Type** | SQL Query |
| **Location** | JH_Demo_v2/ |
| **Queries** | 10 sample queries testing all dimensions, joins, and composable measures |

**Query Highlights:**
- Basic revenue and order count by month
- Order status distribution with fulfillment rate
- Revenue by region (tests snowflake join chain)
- Revenue by market segment (tests customer join)
- Top 10 customers by revenue
- Lineitem analysis by ship mode (tests lineitem join)
- Return flag analysis (tests lineitem join)
- Monthly revenue trend by region (cross-dimensional)
- Order priority analysis
- Composability test (all composable measures in one query)

### 3. Dashboards

#### JH Metrics View Orders Dashboard V1

| Widget | Chart Type | Dimensions | Measures |
|--------|-----------|------------|----------|
| Revenue by Region | Bar | `region_name` | `total_revenue` |
| Order Volume Over Time | Line | `order_month` | `order_count` |
| Order Status Distribution | Pie | `order_status` | `order_count` |
| Top 10 Customers by Revenue | Bar | `customer_name` | `total_revenue` |
| Average Order Value Over Time | Scatter | `order_month` | `avg_order_value` |

**Chart types used:** Bar, Line, Pie, Scatter (4 types)

#### JH Metrics View Orders & Joins Dashboard V1

| Widget | Chart Type | Dimensions | Measures |
|--------|-----------|------------|----------|
| Revenue by Customer Segment | Bar | `market_segment` | `total_revenue` |
| Order Count by Ship Mode | Bar | `ship_mode` | `total_quantity` |
| Order Fulfillment Trends | Line | `order_month` | `fulfillment_rate` |
| Customer Region vs Order Status | Stacked Bar | `region_name`, `order_status` | `order_count` |
| Lineitem Quantity Distribution | Scatter | `total_quantity`, `return_flag` | `total_extended_price` |

**Chart types used:** Bar, Line, Stacked Bar, Scatter (4 types)

### 4. Genie Space

| Asset | Details |
|-------|---------|
| **Name** | JH Metrics View Space V1 |
| **Type** | Genie Space |
| **Data Source** | `orders_metric_view` (Metric View) |
| **Sample Questions** | 6 curated questions |
| **Text Instructions** | Comprehensive dimension/measure reference |
| **Example SQL Queries** | 6 annotated SQL examples |
| **Location** | JH_Demo_v2/ |

**Sample Questions:**
1. Show total revenue broken down by customer region
2. Display order count and revenue by month for the last 24 months
3. Compare total revenue across customer market segments
4. Find the top 10 customers by total revenue
5. Track the order fulfillment rate month over month
6. Analyze quantity and extended price by shipping mode

---

## Asset Summary

| # | Asset | Type | ID / Location |
|---|-------|------|---------------|
| 1 | `catalog_7w4dm4_eq04qz.jh_metrics_view_demo_v1.orders_metric_view` | Metric View | Unity Catalog |
| 2 | Metric View Sample Queries V1 | SQL Query | JH_Demo_v2/ |
| 3 | JH Metrics View Orders Dashboard V1 | Dashboard | JH_Demo_v2/ |
| 4 | JH Metrics View Orders & Joins Dashboard V1 | Dashboard | JH_Demo_v2/ |
| 5 | JH Metrics View Space V1 | Genie Space | JH_Demo_v2/ |
| 6 | readme.md | Documentation | JH_Demo_v2/ |
