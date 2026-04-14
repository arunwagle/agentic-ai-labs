# Create Metric Views — Member Claims Domain

## Role

You are a Databricks Platform Engineer. Your job is to discover the source schema, then design and create Metric Views that implement the KPIs defined in the design document, following the best practices guide.

---

## Step 1: Load Inputs

1. Read `config.md` from this folder. Extract all parameters.
2. Read the **Metric View Best Practices** document (path in config). Internalize the design principles — composability, naming, star schema joins, windowed measures, filtered measures, common pitfalls.
3. Read the **KPI Design Document** (path in config). Read it in full. Every KPI listed is mandatory — implement all or explicitly flag any skipped with a reason.

---

## Step 2: Discover and Profile Source Schema

1. List all tables in `<Source Catalog>.<Source Schema>`.
2. For each table: `DESCRIBE TABLE EXTENDED`, row count, and sample 5 rows.
3. Classify tables as fact, dimension, SCD2/history, or bridge based on what you find.
4. Identify join relationships by matching key columns across tables.
5. Map the source entities referenced in the KPI Design Document to the physical tables you discovered. If a required entity has no matching table, flag it — the corresponding KPIs will be skipped.
6. Present a summary table, entity mapping, and proposed join strategy. Wait for confirmation.

---

## Step 3: Create Metric Views

Using the KPI Design Document as your specification and the Best Practices as your guide:

1. `CREATE SCHEMA IF NOT EXISTS <Target Catalog>.<Target Schema>`.
2. Design the metric view YAML (`version: 1.1`):
   * **Source, Joins, Dimensions**: Derive from the schema profiling in Step 2 and the Best Practices guide.
   * **Measures**: Implement every KPI from the design document — core, window, and additional derived. Follow the formulas, types, formats, and aggregation rules exactly as specified.
3. Create the metric view with `CREATE OR REPLACE VIEW ... WITH METRICS LANGUAGE YAML AS $$ ... $$`.
4. On failure, check column names against DESCRIBE output, fix, and retry up to 3 times.

---

## Step 4: Validate

Test every KPI from the design document:

* Each KPI must return non-null, non-zero results.
* Ratios must fall in expected ranges (e.g., 0–1 for rates).
* Window measures must return data for multiple months with reasonable trends.

If any KPI was skipped due to missing source data, document it explicitly.

---

## Step 5: Create Sample Queries File

Create `<Sample Queries File Name>` with 10-12 queries using `MEASURE()` syntax, organized by the KPI domains from the design document. Each query should include a comment explaining the business question. Save to the Output Folder.

---

## Rules

* All catalog, schema, and asset names come from config — never hardcode.
* Only use columns confirmed via DESCRIBE — never guess.
* Every KPI in the design document must be implemented or explicitly flagged as skipped with a reason. Do not silently omit KPIs.
* On any error: stop immediately, report `❌ EXECUTION HALTED` with error, context, and suggested fix.
* Do not modify this file or config.md.
