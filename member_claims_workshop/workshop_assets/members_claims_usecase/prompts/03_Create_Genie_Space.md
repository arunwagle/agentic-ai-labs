# Create Genie Space

## Role

You are a Databricks Platform Engineer. Your job is to create a Genie space that enables natural-language querying of the Metric View.

> **CRITICAL — The notebook IS the deliverable.**
> The Genie Space Configuration Notebook is a reusable asset that the customer keeps to manage, update, and rebuild their Genie space in the future. You MUST produce this notebook as a fully populated, runnable artifact — then execute it. **Do NOT call the Genie API directly or bypass the notebook workflow under any circumstances.**

---

## Step 1: Load Inputs

1. Read `config.md` from this folder. Extract all parameters.
2. The Metric View must already exist. If it doesn't, run `01_Create_Metric_Views.md` first.
3. Read the **template notebook** at `prompts/Create_Genie_Space_Notebook_Template` (same folder as this prompt). This is a 10-cell notebook with `<<< REPLACE >>>` placeholders in cells 2–7 and **production-ready infrastructure** in cells 8–10. Read every cell — you will need the exact content of cells 8–10 later.

---

## Step 2: Profile the Metric View

1. Run `DESCRIBE TABLE EXTENDED` on the metric view to discover all dimensions and measures.
2. Query distinct values for every categorical dimension.
3. Run total measure aggregations to understand data ranges.
4. Document all findings — these feed into the placeholder replacements below.

---

## Step 3: Delete Existing Genie Space (if any)

Before creating a new Genie Space, **check if one already exists with the same title** and delete it:

1. **List Genie Spaces** in the parent path using the `GET /api/2.0/genie/spaces` API (or list workspace objects in `<Output Folder>`).
2. **Search** for any space whose title matches `<Genie Space Name>` from `config.md`.
3. **If a match is found**:
   - Log: `⚠️ Found existing Genie Space "<title>" (ID: <id>). Deleting before recreate...`
   - Call `DELETE /api/2.0/genie/spaces/<space_id>` to remove it.
   - Verify deletion succeeded (HTTP 200).
   - Log: `✅ Existing Genie Space deleted.`
4. **If no match is found**: Log `ℹ️ No existing Genie Space found. Will create new.` and proceed.

> **Why?** This ensures idempotent runs — the prompt can be re-executed cleanly without leaving orphaned or duplicate spaces.

---

## Step 4: Create the Genie Space Configuration Notebook

> **This step creates a real, runnable notebook in the Output Folder. It is NOT optional.**

### 4a. Delete existing notebook (if any)

Check if a notebook already exists at `<Output Folder>/<Genie Notebook Name>`. If it does, delete it first to ensure a clean copy from the template. Use the Workspace API `DELETE /api/2.0/workspace/delete` with the full path and `recursive: false`.

### 4b. Create the notebook

Create a new notebook at `<Output Folder>/<Genie Notebook Name>` (both values from `config.md`). Use `createAsset` (type = notebook) or equivalent. The notebook must exist in the workspace as a notebook asset before proceeding.

### 4c. Populate cells 1–7 with filled-in content

Using `editAsset` (or the multi-notebook editing capability), add **10 cells** to the new notebook. For cells 1–7, take the template content and **replace every `<<< REPLACE >>>` placeholder** with real values derived from config and Step 2 profiling:

| Cell | Template Variable(s) | Replace With |
|------|---------------------|-------------|
| 1 | `{{DOMAIN_NAME}}` | `Member Claims` (or the domain name from context) |
| 2 | `SPACE_TITLE`, `SPACE_DESCRIPTION`, `WAREHOUSE_ID`, `PARENT_PATH`, `SPACE_ID` | Exact values from `config.md`. Set `SPACE_ID = ""` for first-time creation. |
| 3 | `GENERAL_INSTRUCTIONS` | Full metric view documentation from Step 2: **all dimensions** (name → description → valid values), **all measures** (name → type → formula), `MEASURE()` syntax rules, domain-specific business concepts. This must be a comprehensive multi-line string — not a stub. |
| 4 | `METRIC_VIEW_DESCRIPTIONS` | Python dict mapping metric view FQN → description string |
| 5 | `SAMPLE_QUESTIONS` | Python list of 15–20 natural-language questions spanning all KPI domains |
| 6 | `EXAMPLE_QUESTION_SQLS` | Python list of 15–20 `(question, sql)` tuples teaching Genie correct `MEASURE()` query patterns — cover every dimension and measure at least once |
| 7 | `BENCHMARK_QUESTIONS` | Python list of 15–20 `(question, sql)` tuples for accuracy testing — **different phrasing** from Cell 6 |

### 4d. Copy cells 8–10 verbatim

Cells 8, 9, and 10 contain the `build_serialized_space()` helper, the create/update API call, and the validation logic. **Copy them exactly as they appear in the template — do not modify, summarize, or rewrite them.**

### 4e. Verify the notebook is complete

Before proceeding to Step 5, read back the notebook you just created and confirm:
- It has exactly 10 cells.
- Cells 2–7 contain **no** remaining `<<< REPLACE >>>` placeholders.
- Cells 8–10 are identical to the template.
- All Python code is syntactically valid (strings are properly quoted/escaped, lists and dicts are well-formed).

---

## Step 5: Execute the Notebook

> **You must navigate to the notebook and run the cells there.** Do not simulate execution via `executeCode` or call the API directly.

1. Use `openAsset` to navigate to the new notebook in the Output Folder.
2. In the `continueMessage`, instruct the notebook agent to:
   - Run **Cell 8** (loads helper functions).
   - Run **Cell 9** (creates or updates the Genie space via the API).
   - Run **Cell 10** (validates the space by reading it back).
3. Verify validation output shows: **1 instruction block**, **15–20 sample questions**, **15–20 example SQLs**, **15–20 benchmarks**, and instruction text **> 500 chars**.
4. Update Cell 2 to set `SPACE_ID = "<id from Cell 9 output>"` so the notebook is ready for future updates.

---

## Anti-Patterns — Do NOT Do These

| ❌ Anti-Pattern | ✅ Required Instead |
|----------------|-------------------|
| Call `POST /api/2.0/genie/spaces` directly via `executeCode` or `requests` | Build the notebook, navigate to it, and run Cell 9 which makes the API call |
| Skip notebook creation and "plan to create it later" | Create and fully populate the notebook **before** any Genie API call |
| Leave `<<< REPLACE >>>` placeholders in the notebook | Every placeholder must be replaced with real, profiled values |
| Summarize or truncate `GENERAL_INSTRUCTIONS` | Must be a comprehensive multi-line string covering all dimensions, measures, and rules |
| Modify cells 8, 9, or 10 | Copy verbatim from the template |
| Use `executeCode` to run notebook cells remotely | Use `openAsset` + `continueMessage` to hand off execution to the notebook agent |
| Create a new Genie Space without checking for an existing one | Always search and delete existing space with same title first (Step 3) |

---

## Rules

* All names and paths come from `config.md` — never hardcode.
* All SQL must use `MEASURE()` syntax with `GROUP BY ALL`.
* Cells 8–10 are copied verbatim — do not modify.
* The completed notebook is a **permanent deliverable** in the Output Folder.
* **Idempotency**: Deleting existing Genie Spaces and notebooks before creation ensures the prompt can be re-run cleanly.
* On error: stop, report `❌ EXECUTION HALTED` with error, context, and suggested fix.
* Do not modify this prompt file or `config.md`.
