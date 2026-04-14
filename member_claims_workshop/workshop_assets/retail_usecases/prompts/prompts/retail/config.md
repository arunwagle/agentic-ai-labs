# Workshop Configuration

> **Edit ONLY this file before running the master prompt.**
> All prompts (01, 02, 03) read their parameters from here.

---

## User Identity

| Parameter | Value |
|---|---|
| User Email | `your.name@company.com` |
| Short Name | `workshop` |

> **Naming convention**: All created assets are suffixed with the Short Name to avoid conflicts between workshop participants.
> To derive your Short Name: take the part before `@` in your email and replace `.` with `_`.
> Example: `jane.doe@company.com` → `jane_doe`

## Source Data

| Parameter | Value |
|---|---|
| Source Catalog | `samples` |
| Source Schema | `tpch` |

## Target Environment

| Parameter | Value |
|---|---|
| Target Catalog | `aira_test` |
| Target Schema | `aibi_workshop_schema_test` |

## Output Settings

| Parameter | Value |
|---|---|
| Output Folder | `/Workspace/Users/<User Email>/workshop_output/` |
| SQL Warehouse ID | `<your-sql-warehouse-id>` |

> **Note**: `<User Email>` in Output Folder is automatically resolved from the User Email above.

## Asset Names

> All asset names below include the `_<Short Name>` suffix. Update the Short Name above and the suffixes below will match.

| Parameter | Value |
|---|---|
| Metric View Name | `analytics_metric_view_workshop` |
| Window Measures Metric View Name | `analytics_window_measures_workshop` |
| Dashboard 1 Name | `Core KPIs Dashboard - workshop` |
| Dashboard 2 Name | `Relationship Analytics Dashboard - workshop` |
| Genie Space Name | `Analytics Genie - workshop` |
| Sample Queries File Name | `Metric View Sample Queries - workshop` |

## Execution Options

| Parameter | Value |
|---|---|
| Clean Start | `yes` |
| Create Window Measures | `yes` |
| Generate Documentation | `yes` |

---

## How to Use

1. Update **User Email** with your Databricks login email.
2. Update **Short Name** by taking the part before `@` and replacing `.` with `_`.
3. Update all **Asset Names** to end with `_<your Short Name>` (or `- <your Short Name>` for dashboards/spaces).
4. Replace `<your-warehouse-id>` with your SQL warehouse ID.
5. Update Source Catalog/Schema to point to your data.
6. Update Target Catalog/Schema to where you want assets created.
7. Run the master prompt `00_Workshop_Master_Prompt.md` — it will read this config and execute all steps.

### Quick Setup Example

For user `jane.doe@company.com`:

| Parameter | Value |
|---|---|
| User Email | `jane.doe@company.com` |
| Short Name | `jane_doe` |
| Metric View Name | `analytics_metric_view_jane_doe` |
| Window Measures Metric View Name | `analytics_window_measures_jane_doe` |
| Dashboard 1 Name | `Core KPIs Dashboard - jane_doe` |
| Dashboard 2 Name | `Relationship Analytics Dashboard - jane_doe` |
| Genie Space Name | `Analytics Genie - jane_doe` |
| Sample Queries File Name | `Metric View Sample Queries - jane_doe` |
| Output Folder | `/Workspace/Users/jane.doe@company.com/workshop_output/` |
