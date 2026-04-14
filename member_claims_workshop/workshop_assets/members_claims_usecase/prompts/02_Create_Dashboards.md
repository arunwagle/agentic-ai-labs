# Create Dashboards — Member Claims Domain

## Role

You are a Databricks Platform Engineer. Your job is to create multi-page dashboards powered by the Member Claims Metric View.

---

## Step 1: Load Inputs

1. Read `config.md` from this folder. Extract all parameters.
2. The Metric View must already exist. If it doesn't, run `01_Create_Metric_Views.md` first.
3. Read the **KPI Design Document** (path in config) — specifically **Section 11 (Dashboard Mapping)** for the recommended page layouts and KPI-to-widget assignments. Use this as the authoritative guide for which KPIs appear on which pages and in which chart types.

---

## Step 2: Profile the Metric View

1. Run `DESCRIBE TABLE EXTENDED` on `<Target Catalog>.<Target Schema>.<Metric View Name>` to discover all available dimensions and measures.
2. Run a sample query to see actual data.
3. Classify dimensions (time, geographic, demographic, LOB, claim, clinical, provider, status) and measures (financial, volume, entity, derived KPIs, **window measures**).

---

## Step 3: Delete Existing Dashboards (if any)

Before creating dashboards, **check if dashboards with the same names already exist** in the Output Folder and delete them:

1. **Search** the workspace (using `searchAssets` or the Workspace API) for dashboards matching `<Dashboard 1 Name>` and `<Dashboard 2 Name>` from `config.md`.
2. **Also list** objects in `<Output Folder>` and check for any `.lvdash.json` files matching the dashboard names.
3. **For each match found**:
   - Log: `⚠️ Found existing dashboard "<name>" (ID: <id>). Deleting before recreate...`
   - Delete the dashboard using the Workspace API: `POST /api/2.0/workspace/delete` with the dashboard path and `recursive: false`.
   - Verify deletion succeeded.
   - Log: `✅ Existing dashboard deleted.`
4. **If no matches found**: Log `ℹ️ No existing dashboards found. Will create new.` and proceed.

> **Why?** This ensures idempotent runs — the prompt can be re-executed cleanly without leaving orphaned or duplicate dashboards.

---

## Step 4: Create Dashboard 1 — KPIs Overview

Create `<Dashboard 1 Name>` with multiple pages as specified in the KPI Design Document's Dashboard Mapping (Section 11). At minimum, cover:

* **Financial overview**: Cost distribution by key dimensions, monthly trends, category breakdowns, top-N cost drivers.
* **Claims analysis**: Cross-dimensional comparisons, performance KPIs (denial rate, clean claim rate), summary tables.
* **Member demographics**: Geographic distribution, demographic breakdowns, cost burden analysis.

**All available measures** from the metric view — including window measures (rolling PMPM, MoM growth, etc.) — must be represented on appropriate dashboard pages per the design document's mapping. If a window measure requires SQL window functions (`LAG`, `AVG OVER`) not expressible in `MEASURE()` syntax, create a dataset using a CTE: inner query with `MEASURE()` for monthly aggregates, outer query with the window function.

Use at least 4 different chart types. All dataset queries must use `MEASURE()` syntax against the metric view (except window-function CTE datasets as described above).

---

## Step 5: Create Dashboard 2 — Utilization & Provider Analytics

Create `<Dashboard 2 Name>` with pages covering:

* **Utilization patterns**: Volume trends by LOB, place of service distribution, inpatient vs outpatient spend.
* **Provider insights**: Specialty rankings, participating vs non-participating provider analysis, performance scatter plots.
* **Operational metrics**: Adjudication status, denial trends, payment ratios, detailed cross-reference tables.

---

## Step 6: Global Filters (Required on Both Dashboards)

Every dashboard must include at least 3 global filter widgets linked to all datasets:

1. **Date range filter** on the primary time dimension (e.g., Service Month) — allows users to narrow the analysis window.
2. **Multi-select filter** on Line of Business — allows slicing by product (Commercial, Medicare, Medicaid, etc.).
3. **Multi-select filter** on at least one additional dimension discovered during profiling (e.g., Claim Type, Member State, Benefit Category) — choose whichever adds the most analytical value based on the data.

Add more filters if the data warrants it, but these 3 are the minimum.

**Filter–dataset compatibility**: When binding a filter to datasets, verify each dataset has the filter column in its schema. If a dataset lacks the column, either add it to the dataset query or skip that binding — never bind to a non-existent column.

---

## Step 7: Apply Custom Theme

After creating each dashboard, apply a custom theme through the dashboard settings. Configure:

* **Canvas colors**: Choose appropriate background colors for both light and dark mode variants.
* **Visualization palette**: Set a cohesive color palette for charts and graphs — use colors that distinguish the key dimensions well (e.g., distinct colors per Line of Business).
* **Fonts**: Set a clean, professional font style and size for readability.
* **Title alignment**: Use consistent widget title alignment across all widgets.

Apply the same theme to both dashboards for a consistent look. If a workspace theme is already configured, start from that and customize as needed.

---

## Step 8: Validate and Organize

1. Verify no 'Unknown Column' errors on any widget.
2. Confirm all charts render with data and filters work correctly.
3. Verify the custom theme is applied and renders correctly in both light and dark modes.
4. **Verify every KPI from the design document's Dashboard Mapping (Section 11) is represented on the appropriate page.**
5. Move dashboards to the Output Folder.

---

## Rules

* All catalog, schema, and asset names come from config — never hardcode.
* All datasets must use `MEASURE()` syntax, except window-function CTE datasets where `MEASURE()` alone cannot express the calculation.
* **Bar chart color handling**: When creating a bar chart with a single series (no color split), omit the `color` field entirely. Only use `color` when explicitly grouping by a categorical dimension. Never leave color as an undefined or placeholder column.
* **Idempotency**: Deleting existing dashboards before creation (Step 3) ensures the prompt can be re-run cleanly without orphaned or duplicate assets.
* On any error: stop immediately, report `❌ EXECUTION HALTED` with error, context, and suggested fix.
* Do not modify this file or config.md.
