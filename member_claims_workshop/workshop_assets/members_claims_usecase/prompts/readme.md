# Member Claims workshop prompts

## Configuration

**All workshop parameters belong in `config.md`.** Edit only that file (user email, short name, catalogs, schemas, warehouse id, asset names, output folder, flags). The master prompt and step prompts read values from there.

After you change `config.md`, keep any **Unity Catalog** schema names and **workspace paths** in the notebooks aligned with what you set in config (for example source schema for synthetic data and target schema for metric views).

---

## Before you run Genie Code (`00_Workshop_Master_Prompt.md`)

Run these notebooks **manually in Databricks** in order. They prepare base tables and metric views that the Genie pipeline assumes already exist.

| Order | Notebook | Purpose |
|------:|----------|---------|
| 1 | `../notebooks/Member Claims Prd Gold Gen Synthetic Data Notebook.ipynb` | Generates synthetic member and claims data in your source schema. |
| 2 | `../notebooks/Member Cliams Prd Gold Metric Views - Setup Notebook.ipynb` | Creates the gold-layer metric views used by dashboards and Genie. |

Then attach and run **`00_Workshop_Master_Prompt.md`** in Genie Code so the agent can execute the metric-view build, dashboards, and Genie space steps defined in `01`–`03`.
