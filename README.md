# 🏭 Genie Family PoC — Manufacturing Industry Workshop

> **End-to-end Proof of Concept for Databricks Genie One, Genie Agents (Spaces), Genie Code, and Genie Mobile**

## 🎯 Overview

This repository contains a complete, runnable PoC workshop that demonstrates all four Databricks Genie products using a synthetic manufacturing operations dataset. It's designed for **customer enablement**, **field demos**, and **hands-on workshops**.

| Notebook | Focus | Persona | Time |
|---|---|---|---|
| **01** Foundation | Synthetic data + UC setup | All | ~5 min |
| **02** Genie Agent | Space setup + curation + benchmarking | Analyst → Business User | ~10 min |
| **03** Genie One | Business user experience + enablement | Executive, Business User | ~5 min |
| **04** Genie Code | Technical practitioner demos | Engineer, Data Scientist | ~10 min |
| **05** Genie Mobile | Mobile deployment + demo guide | IT Admin, Executive | ~5 min |
| **Total** | | | **~35 min** |

## 🚀 Quick Start

### Option 1: Automated Setup (Recommended)

```bash
# Clone the repo
git clone https://github.com/<your-org>/genie-family-poc.git
cd genie-family-poc

# Install Databricks SDK
pip install databricks-sdk

# Upload notebooks to your workspace
python scripts/setup.py \
    --workspace-url https://your-workspace.cloud.databricks.com \
    --token dapi_your_token_here
```

### Option 2: Bash Script

```bash
# Configure Databricks CLI first
databricks configure --token

# Run setup
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### Option 3: Manual Import

1. Download the `.ipynb` files from the `notebooks/` directory
2. In your Databricks workspace, go to **Workspace** → **Import**
3. Upload each notebook
4. Run them in order (01 → 02 → 03 → 04 → 05)

## 📋 Prerequisites

| Requirement | Details |
|---|---|
| **Databricks workspace** | Unity Catalog enabled |
| **DBR version** | 14.0+ (dbldatagen pre-installed) |
| **Compute** | Serverless SQL Warehouse (recommended) |
| **Permissions** | CREATE CATALOG, CREATE SCHEMA |
| **Features** | Partner-Powered AI enabled |

## 🏗️ What Gets Created

### Data Assets (Notebook 01)
- **Catalog**: `genie_family_poc`
- **Schema**: `genie_family_poc.manufacturing`
- **10 tables**: 5 dimensions + 4 fact tables + 1 aggregate
- **2 views**: Pre-joined production and quality summaries
- **~500K+ rows** of realistic synthetic manufacturing data

### Genie Agent (Notebook 02)
- **Manufacturing Operations Intelligence** agent
- 18 text instructions covering business rules and terminology
- 10+ example SQL queries organized by persona
- 12 benchmark questions for accuracy evaluation

### Demo Assets (Notebooks 03-05)
- Genie One homepage configuration and demo script
- 16 demo questions across 4 personas
- 3 scheduled task templates
- Genie Code prompts for chat mode and agent mode
- Mobile security checklist and 10-step demo script

## 📊 Manufacturing Domain

The PoC uses a **manufacturing operations** domain with:
- **19 active plants** across North America, Europe, Asia Pacific, and South America
- **5 product categories**: Automotive Parts, Electronics, Heavy Machinery, Consumer Goods, Aerospace Components
- **Key metrics**: Yield Rate, Scrap Rate, Quality Pass Rate, Equipment Uptime, OEE
- **Personas**: Executive, Operations Manager, Quality Engineer, Supply Chain Analyst, Maintenance Engineer

## 🎓 Workshop Facilitation Guide

### Session 1: Foundation + Genie Agent (45 min)
1. Run Notebook 01 together (5 min)
2. Walk through Notebook 02, explaining each curation layer (20 min)
3. Hands-on: Participants ask questions in the Genie Agent UI (20 min)

### Session 2: Genie One + Mobile (30 min)
1. Demo Genie One using the script in Notebook 03 (15 min)
2. Install and demo the mobile app using Notebook 05 (15 min)

### Session 3: Genie Code (30 min)
1. Live demo of Chat Mode prompts from Notebook 04 (15 min)
2. Live demo of Agent Mode (dashboard creation) (15 min)

## 🔧 Customization

### Change the Industry
The synthetic data generator in Notebook 01 can be adapted to any industry:
- **Financial Services**: Replace with accounts, transactions, risk scores
- **Healthcare**: Replace with patients, encounters, lab results
- **Retail**: Replace with customers, orders, products, stores
- **Energy**: Replace with assets, readings, maintenance records

### Change the Scale
Modify `NUM_ROWS_SCALE` in Notebook 01:
- `1` = Default (~500K rows, ~5 min)
- `5` = Medium (~2.5M rows, ~15 min)
- `10` = Large (~5M rows, ~30 min)

## 📝 License

Internal Databricks use. Adapt and share with customers as needed.

## 👤 Author

Built by the Databricks Field Engineering team for customer enablement and PoC delivery.

## 🔗 Resources

- [Genie Documentation](https://docs.databricks.com/aws/en/genie)
- [Genie One](https://docs.databricks.com/aws/en/genie-one)
- [Genie Code](https://docs.databricks.com/aws/en/genie-code)
- [Genie Agents](https://docs.databricks.com/aws/en/genie-agents)
- [Genie Mobile](https://docs.databricks.com/aws/en/genie-one/mobile)
- [go/genie](https://home.databricks.com/sales/field-performance/products/genie-and-ai-bi/) (internal)
