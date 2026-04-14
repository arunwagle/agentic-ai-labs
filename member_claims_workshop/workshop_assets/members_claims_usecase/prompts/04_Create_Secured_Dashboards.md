# Create Secured Dashboards — Row-Level Security by Line of Business

## Role

You are a Databricks Platform Engineer. Your job is to apply Row-Level Security (RLS) on the source tables so that dashboards built on the Member Claims Metric View automatically filter data by the viewer's Line of Business (LOB) group membership.

---

## Step 1: Load Inputs

1. Read `config.md` from this folder. Extract all parameters.
2. The Metric View and both Dashboards must already exist. If they don't, run `01_Create_Metric_Views.md` and `02_Create_Dashboards.md` first.
3. Identify the source table that holds the LOB column by inspecting the Metric View definition:
   - Run `DESCRIBE TABLE EXTENDED <Target Catalog>.<Target Schema>.<Metric View Name>` to get the `view_query_text`.
   - From the YAML, identify the `source` table and the join table containing `clm_line_of_business`.

---

## Step 2: Discover LOB Values

1. Query the source table to get all distinct `clm_line_of_business` values and their row counts.
2. Record the LOB codes (e.g., `COM`, `MCR`, `MCD`, `EXC`, `MMP`) — these drive the group names and filter logic.
3. The corresponding account-level groups already exist using the naming convention `lob_<lob_code_lowercase>_group`, plus `lob_all_group` for admins/executives. Do not attempt to create groups.

---

## Step 3: Create the Row Filter Function

Create a SQL UDF in `<Source Catalog>.<Source Schema>` that returns `TRUE` only for rows the current user is allowed to see.

Use `OR`-based logic (not `CASE`) so multi-group membership works correctly:

```sql
CREATE OR REPLACE FUNCTION <Source Catalog>.<Source Schema>.lob_row_filter(lob STRING)
RETURNS BOOLEAN
RETURN
  IS_ACCOUNT_GROUP_MEMBER('lob_all_group')
  OR (IS_ACCOUNT_GROUP_MEMBER('lob_<lob1>_group') AND lob = '<LOB1>')
  OR (IS_ACCOUNT_GROUP_MEMBER('lob_<lob2>_group') AND lob = '<LOB2>')
  -- ... one OR branch per LOB value discovered in Step 2
  ;
```

**Key behaviors:**
- `IS_ACCOUNT_GROUP_MEMBER()` checks the current user's groups at query time.
- `lob_all_group` is evaluated first — admins see everything.
- Users in no matching group see **no rows** (deny by default).

---

## Step 4: Apply the Row Filter to the Source Table

```sql
ALTER TABLE <Source Catalog>.<Source Schema>.<claim_header_table>
SET ROW FILTER <Source Catalog>.<Source Schema>.lob_row_filter
ON (clm_line_of_business);
```

Because the Metric View reads from this table, the filter **automatically propagates** — no changes needed to the Metric View YAML or dashboard queries.

---

## Step 5: Verify RLS Propagation

Test at each layer to confirm the filter is working:

1. **Source table** — query `<Source Catalog>.<Source Schema>.<claim_header_table>` grouped by `clm_line_of_business`. Only the current user's allowed LOBs should appear.
2. **Metric View** — query `<Target Catalog>.<Target Schema>.<Metric View Name>` grouped by `line_of_business`. Same filtering should apply.
3. **Admin override** — run as a user in `lob_all_group` and confirm all LOBs are visible.

---

## Step 6: Create the Secured Dashboard

The secured dashboard is **identical** to the original — same datasets, widgets, and pages. RLS is enforced at the table level, so no query changes are needed.

1. Clone `<Dashboard 1 Name>` → rename to `<Dashboard 1 Name> - Secured`.
2. Clone `<Dashboard 2 Name>` → rename to `<Dashboard 2 Name> - Secured`.
3. Verify all widgets render correctly with the filtered data.

---

## Step 7: Share the Secured Dashboards

Grant access to the LOB groups:

- Each `lob_<lob_code>_group` → **Can View**
- `lob_all_group` → **Can Edit**

Publish the dashboards. The RLS filter runs under the **viewer's identity**, so each user sees only their LOB data.

---

## Rollback

To remove the RLS filter:

```sql
ALTER TABLE <Source Catalog>.<Source Schema>.<claim_header_table>
DROP ROW FILTER;

DROP FUNCTION IF EXISTS <Source Catalog>.<Source Schema>.lob_row_filter;
```

---

## Rules

* All catalog, schema, and asset names come from `config.md` — never hardcode.
* The row filter function must use `OR`-based logic to support multi-group membership.
* Default behavior is **deny** — users not in any LOB group see no rows.
* The Metric View and dashboard queries are never modified — RLS is enforced at the source table.
* On any error: stop immediately, report `❌ EXECUTION HALTED` with error, context, and suggested fix.
* Do not modify this file or `config.md`.
