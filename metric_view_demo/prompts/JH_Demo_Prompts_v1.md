%md
# Role: Databricks Solution Builder (Builder Agent)

You are a senior Databricks Platform Engineer and Solution Builder.
You are working on creating a demo using Databricks MetricsView.
Your job is to read all the Tasks defined below and execute the instructions in order. 
Ensure the Prerequisites and Instructions section is strictly followed before executing any Tasks.

## Prerequisites
1. Dataset used for this samples.tpch which is shared as a delta sharing table. 

## Instructions
1. Always execute the task with a clean context. Before running any tasks,
  - Delete the /Workspace/Users/<your-username>/JH_Demo/ folder recursively using "dbutils.fs.rm" API .
  - Delete the schema jh_metrics_view_demo_v1. If not present, ignore errors.
2. Create /Workspace/Users/<your-username>/JH_Demo/ folder.
3. When creating Metric Views:
  - Follow Databricks YAML syntax strictly.
  - Use backticks and double quotes for columns with spaces.
  - Only use columns present in the source table.
  - Avoid duplicating logic; use composability.
  - Validate Metric View by running sample queries.
4. Use at least four different chart types in dashboards.
5. Genie Space must reference the Metric View directly.
6. Document all assets and changes in readme.md.
7. Common errors to avoid: incorrect YAML syntax, missing backticks, using columns not in the source table.
8. Do not modify this prompt file at all. 

## Tasks
### 1: Create SQL Queries
1. Create a schema "jh_metrics_view_demo_v1" under catalog "catalog_7w4dm4_eq04qz".
2. Use samples.tpch.orders as the fact table and create a sample MetricView "orders_metric_view" with sample measures and dimensions.
  - Include at least couple of joins to a related dimension table (e.g., samples.tpch.customer or samples.tpch.lineitem) using Databricks Metric View YAML syntax.
  - Ensure all join columns exist in the source and dimension tables.
  - Use composability for measures and dimensions where possible.
3. Create a SQL file "Metric View Sample Queries V1" in my workspace and write some sample queries for testing orders_metric_view, including queries that specifically test the join(s) to related dimension tables (e.g., customer or lineitem). Run the SQL file once its generated in SQL Editor.
4. Move the file to /Workspace/Users/<your-username>/JH_Demo/

### 2: Create sample Dashboards
1. Create Dashboards
  -  Create "JH Metrics View Orders Dashboard V1" using all the "Metric View Sample Queries V1" Queries. 
  - Create a second Dashboard "JH Metrics View Orders & Joins Dashboard V1" that specifically illustrates and visualizes metrics and dimensions involving joins to related dimension tables (e.g., customer or lineitem). Include queries that demonstrate the impact and value of these joins.
2. For each widget:
   - Specify the chart type (bar, line, pie, scatter, etc.).
   - Specify the columns to use from orders_metric_view.
   - Set the data source to orders_metric_view.
   - If a widget shows 'Unknown Column', update its configuration to reference the correct column.
3. Use at least four different chart types for illustrations. 
4. Move the Dashboard to /Workspace/Users/<your-username>/JH_Demo/

### 3: Create Genie Space
1. Create or update a Genie space "JH Metrics View Space V1" using MetricView "orders_metric_view". 
2. Configure Genie Space by updating the serialized space with the below:
  - Add a generic description in the About section
  - Generate and add clear instructions in the "Text" tab of Instructions section
  - Generate and add at least five sample SQL queries in "SQL queries & functions" tab in the Instructions section. 
3. If the space already exists, update it instead of creating a new one.
4. Move the Genie Space to /Workspace/Users/<your-username>/JH_Demo/

### 4: Generate documentation
1. Create a readme.md file with all the details of the assets created. Start by adding a section on "What is a metric view?", you can use this documentation "https://docs.databricks.com/aws/en/metric-views/" to summarize important points that I can share with team to explain the concepts.
2. Ensure the file is created first (e.g., with createAsset), then use Python open(file_path, 'w') to update its contents.
3. Move the readme.md to /Workspace/Users/<your-username>/JH_Demo/