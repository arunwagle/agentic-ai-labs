# Workshop Configuration — Member Claims Use Case

> **Edit ONLY this file before running the master prompt.**

## Parameters

| Parameter | Value |
|---|---|
| User Email | `your.name@company.com` |
| Short Name | `workshop` |
| Source Catalog | `aira_test` |
| Source Schema | `aibi_workshop_schema_day2` |
| Target Catalog | `aira_test` |
| Target Schema | `aibi_workshop_mv_schema` |
| Output Folder | `/Workspace/Users/<User Email>/Customers/Member_Claims_Workshop/workshop_assets/members_claims_usecase/day2` |
| SQL Warehouse ID | `<your-sql-warehouse-id>` |
| Metric View Name | `member_claims_metric_view_workshop` |
| Dashboard 1 Name | `Member Claims KPIs Dashboard - workshop` |
| Dashboard 2 Name | `Member Claims Utilization Dashboard - workshop` |
| Genie Space Name | `Member Claims Analytics Genie - workshop` |
| Genie Notebook Name | `Genie Space Configuration - Member Claims - workshop` |
| Sample Queries File Name | `Member Claims Sample Queries - workshop` |
| Clean Start | `yes` |
| Generate Documentation | `yes` |

## Reference Documents

| Document | Path |
|---|---|
| KPI Design | `/Workspace/Users/your.name@company.com/Customers/Member_Claims_Workshop/workshop_assets/members_claims_usecase/design/Member-Claim-KPI-Design.md` |
| Metric View Best Practices | `/Workspace/Users/your.name@company.com/Customers/Member_Claims_Workshop/workshop_assets/metric_view_best_practices.md` |

## How to Use

1. Update **User Email** and **Short Name** (part before `@`, replace `.` with `_`).
2. Update all asset names to end with `_<your Short Name>` or `- <your Short Name>`.
3. Set your **SQL Warehouse ID**, Source/Target catalogs and schemas.
4. Run `00_Workshop_Master_Prompt.md` — it reads this config and executes all steps.
