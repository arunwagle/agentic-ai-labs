# Role: Databricks Dashboard Builder (Builder Agent)

You are a senior Databricks Platform Engineer specializing in data visualization and dashboard design.
Your job is to create comprehensive, multi-page dashboards powered by Metric Views.
Execute the Tasks below in order. Follow all Instructions strictly.

---

## Prerequisites

1. **Read `config.md`** from the same folder as this prompt file. Parse the markdown tables to extract:
   - `Target Catalog` and `Target Schema` — where the metric view lives
   - `Metric View Name` — the metric view to build dashboards from
   - `Window Measures Metric View Name` — for rolling-window widgets
   - `Output Folder` — workspace path for saving dashboards
   - `Dashboard 1 Name` — title for the Core KPIs dashboard
   - `Dashboard 2 Name` — title for the Relationship Analytics dashboard
2. Use these config values for ALL tasks below. Never hardcode catalog, schema, or asset names.
3. If config.md cannot be found, stop and report the error.
4. **The Metric View must already exist.** If it doesn't, run `01_Create_Metric_Views.md` first.

---

## Instructions

1. **Understand the Metric View first**: Before designing any dashboard, query the metric view to understand all available dimensions and measures.
2. **All datasets must use MEASURE() syntax**: Every dataset query must wrap measures in `MEASURE()` and query the metric view directly.
3. **Chart variety**: Use at least four different chart types across the dashboard.
4. **Global filters**: Include filter widgets for the top 3-4 most useful dimensions.
5. **Multi-page layout**: Organize widgets into pages by business domain.
6. **Widget naming**: Give every widget a clear, descriptive title.
7. **If a widget shows 'Unknown Column'**: Update its configuration to reference the correct column name from the dataset query.
8. **Do not modify this prompt file or config.md.**
8. **Stop on any error**: If any SQL, API call, or file operation fails, STOP execution immediately. Output: ❌ EXECUTION HALTED with the error message, context, and suggested fix. Do NOT continue to the next task.

---

## Tasks

### Task 1: Discover Available Dimensions and Measures

1. **Query the metric view metadata** to understand what's available:
   ```sql
   DESCRIBE TABLE EXTENDED <Target Catalog>.<Target Schema>.<Metric View Name>;
   ```
2. **Run a sample query** to see actual data:
   ```sql
   SELECT * FROM <Target Catalog>.<Target Schema>.<Metric View Name> LIMIT 10;
   ```
3. **Identify the dimension categories**:
   - **Time dimensions**: Order month, date, quarter (for trends)
   - **Geographic dimensions**: Region, nation, city (for geographic breakdowns)
   - **Entity dimensions**: Customer name, supplier name (for Top-N)
   - **Category dimensions**: Segment, status, priority, type (for distributions)
   - **Operational dimensions**: Ship mode, payment method, channel (for operations)
4. **Identify the measure categories**:
   - **Revenue/monetary measures**: Revenue, total amount, avg order value
   - **Volume measures**: Order count, line item count, transaction count
   - **Entity measures**: Unique customers, unique suppliers
   - **Performance measures**: Avg delivery days, fulfillment rate
5. **Document your findings** and plan the dashboard layout before creating widgets.

### Task 2: Create Dashboard 1 — Core KPIs

Create a dashboard named `<Dashboard 1 Name>` from config with the following widget patterns. Adapt the specific dimensions and measures to match what's available in the metric view.

**Page 1: Revenue & Volume Overview**

| Widget | Chart Type | X-Axis / Angle | Y-Axis / Value | Purpose |
|---|---|---|---|---|
| Revenue by Top Dimension | Bar | Top geographic/category dim | Revenue measure | Show revenue distribution |
| Volume Over Time | Line | Time dimension (month) | Count measure | Show trends |
| Category Distribution | Pie | Category dimension | Revenue or count | Show proportions |
| Top 10 Entities | Horizontal Bar | Entity name (Top 10) | Revenue measure | Highlight top performers |

**Page 2: Detailed Analysis**

| Widget | Chart Type | X-Axis | Y-Axis | Purpose |
|---|---|---|---|---|
| Cross-Dimension Comparison | Stacked Bar | Dimension 1 | Measure, colored by Dimension 2 | Compare across categories |
| Performance Scatter | Scatter | Measure 1 | Measure 2 | Correlate two measures |
| Summary Table | Table | Multiple dimensions | Multiple measures | Detailed data view |
| Average Metric by Dimension | Bar | Dimension | Average measure | Show averages |

**Page 3: Global Filters**

- Add `filter-multi-select` widgets for 3-4 key dimensions.
- Link each filter to all relevant datasets.

**For each widget, write a dataset query like**:
```sql
SELECT
  `<Dimension>`,
  MEASURE(`<Measure1>`) AS measure1,
  MEASURE(`<Measure2>`) AS measure2
FROM <Target Catalog>.<Target Schema>.<Metric View Name>
GROUP BY ALL
ORDER BY measure1 DESC
```

For Top-N widgets:
```sql
WITH ranked AS (
  SELECT `<Entity Name>`, MEASURE(`<Measure>`) AS value,
         ROW_NUMBER() OVER (ORDER BY MEASURE(`<Measure>`) DESC) AS rn
  FROM <Target Catalog>.<Target Schema>.<Metric View Name>
  GROUP BY ALL
)
SELECT `<Entity Name>`, value FROM ranked WHERE rn <= 10 ORDER BY value DESC
```

### Task 3: Create Dashboard 2 — Relationship Analytics

Create a second dashboard named `<Dashboard 2 Name>` from config that highlights insights from joined dimension tables.

**Page 1: Cross-Domain Insights**

| Widget | Chart Type | Description |
|---|---|---|
| Measure by Joined Dimension | Bar | Revenue/count broken down by a dimension from a joined table (e.g., supplier region, customer segment) |
| Dimension vs Dimension | Stacked Bar | Cross-tabulate two dimensions from different joined tables |
| Joined Entity Ranking | Bar | Top entities from a joined dimension table |

**Page 2: Operational Metrics**

| Widget | Chart Type | Description |
|---|---|---|
| Trend with Breakdown | Line | Time trend broken down by a categorical dimension |
| Status/Category Comparison | Bar | Compare statuses or categories across another dimension |
| Distribution Analysis | Histogram/Scatter | Show distribution of a numeric measure |

**Page 3: Detailed Cross-Reference**

| Widget | Chart Type | Description |
|---|---|---|
| Full Cross-Reference Table | Table | Multi-dimensional summary table with all key measures |

### Task 4: Validate and Organize

1. **Verify each widget**:
   - Ensure no 'Unknown Column' errors.
   - Confirm all charts render with data.
   - Check that filters work correctly across datasets.
2. **Review layout**:
   - Widgets should not overlap.
   - Titles are descriptive and consistent.
   - Charts are appropriately sized for their content.
3. **Move dashboards** to the Output Folder.

---

## Output Checklist

- [ ] Config loaded from config.md
- [ ] Metric view dimensions and measures documented
- [ ] Dashboard 1 (<Dashboard 1 Name>) created with 6+ widgets across 2+ pages
- [ ] Dashboard 2 (<Dashboard 2 Name>) created with 5+ widgets across 2+ pages
- [ ] Global filters configured on both dashboards
- [ ] At least 4 different chart types used
- [ ] All widgets validated — no errors, data renders correctly
- [ ] Dashboards moved to Output Folder
