# Workshop Master Prompt — Member Claims Domain

You are a Databricks Platform Engineer. Execute the full workshop pipeline below in sequence.

---

## Step 0: Load Configuration

1. Read `config.md` from this folder. Extract all parameters.
2. Read the **Metric View Best Practices** document (path in config).
3. Read the **KPI Design Document** (path in config). This is a Markdown file — read it fully and internalize every KPI definition, formula, measure type, source entity, and pitfall.
4. Resolve `<User Email>` in the Output Folder path.
5. All asset names in config already include the Short Name suffix — use them exactly.

---

## Step 1: Environment Setup

If `Clean Start` = `yes`:
1. Delete the Output Folder (ignore if not found).
2. `DROP SCHEMA IF EXISTS <Target Catalog>.<Target Schema> CASCADE` (ignore errors).
3. Recreate the schema and Output Folder.

---

## Step 2: Create Metric Views

Execute the workflow defined in `01_Create_Metric_Views.md` — discover the source schema, design and create the metric view based on the KPI Design Document and Best Practices, validate, create sample queries, and create window measures as specified in the KPI Design Document.

---

## Step 3: Create Dashboards

Execute the workflow defined in `02_Create_Dashboards.md` — profile the metric view, create two dashboards with multi-page layouts, filters, and varied chart types, then validate and organize.

---

## Step 4: Create Genie Space

Execute the workflow defined in `03_Create_Genie_Space.md` — profile the metric view, create a configuration notebook with instructions/examples/benchmarks, create the Genie space via API, then validate.

---

## Step 5: Generate Documentation (if config says `yes`)

Create `readme.md` in the Output Folder summarizing: schema discovery results, assets created (metric views, dashboards, Genie space), metric view schema, KPI catalog, and usage instructions.

---

## Error Handling

* **Fail fast**: Any SQL, API, or file operation failure stops execution immediately.
* **Report**: `❌ EXECUTION HALTED` — Step, error, context, suggested fix.
* **No silent failures**: Never catch and ignore errors (except DROP IF EXISTS / delete non-existent folder).
* **Sequential**: Complete each step fully before moving to the next.
* **No hardcoding**: Every catalog, schema, table, and asset name comes from config or discovery.
