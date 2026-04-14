# Workshop Configuration

> **Edit ONLY this file before running any prompt.**
> All prompts (00–03) read their parameters from here.
> No domain knowledge is required — the agent discovers everything from the data.

---

## User Identity

| Parameter | Value |
|---|---|
| User Email | `<your-email@company.com>` |
| Short Name | `<first_last>` |

> **Naming rule**: Derive Short Name from email — take the part before `@`, replace `.` with `_`.
> Example: `jane.doe@company.com` → `jane_doe`

## Source Data

| Parameter | Value |
|---|---|
| Source Catalog | `samples` |
| Source Schema | `tpch` |

> Point this to ANY catalog and schema. The agent will discover all tables, classify them as fact/dimension, identify joins, and build everything automatically.

## Target Environment

| Parameter | Value |
|---|---|
| Target Catalog | `aira_test` |
| Target Schema | `workshop_<Short Name>` |

> Each user gets their own schema to avoid conflicts.

## Infrastructure

| Parameter | Value |
|---|---|
| Output Folder | `/Workspace/Users/<User Email>/workshop_output/` |
| SQL Warehouse ID | `<your-sql-warehouse-id>` |

## Execution Options

| Parameter | Value |
|---|---|
| Clean Start | `yes` |
| Create Window Measures | `yes` |
| Generate Documentation | `yes` |

---

## How to Use

1. Fill in **User Email** and **Short Name**.
2. Set **Source Catalog / Schema** to your data (or keep `samples.tpch` for a quick demo).
3. Set **Target Catalog** to a catalog you have CREATE SCHEMA privileges on.
4. Set your **SQL Warehouse ID**.
5. Open a new notebook, paste the contents of `00_Master_Prompt.md` into a markdown cell, and let Genie Code execute.

### Quick Setup Example — jane.doe@company.com

| Parameter | Value |
|---|---|
| User Email | `jane.doe@company.com` |
| Short Name | `jane_doe` |
| Target Schema | `workshop_jane_doe` |
| Output Folder | `/Workspace/Users/jane.doe@company.com/workshop_output/` |
