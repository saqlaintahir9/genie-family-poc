#!/bin/bash
# ============================================================
# Genie Family PoC — Automated Setup Script
# ============================================================
# This script uploads all notebooks to a Databricks workspace
# and optionally runs the foundation notebook to create data.
#
# Prerequisites:
#   1. Databricks CLI installed and configured
#      pip install databricks-cli
#      databricks configure --token
#   2. Access to a Databricks workspace with Unity Catalog
#   3. CREATE CATALOG permission
#
# Usage:
#   chmod +x setup.sh
#   ./setup.sh
#
# Options:
#   ./setup.sh --workspace-url https://your-workspace.cloud.databricks.com
#   ./setup.sh --target-dir /Users/your-email@company.com/Genie_Family_PoC
#   ./setup.sh --run-foundation   # Also runs Notebook 1 to create data
# ============================================================

set -e

# Default configuration
TARGET_DIR="${TARGET_DIR:-/Workspace/Users/$(databricks current-user me --output json 2>/dev/null | python3 -c "import sys,json; print(json.load(sys.stdin).get('userName',''))" 2>/dev/null || echo 'shared')/Genie_Family_PoC}"
WORKSPACE_URL="${WORKSPACE_URL:-}"
RUN_FOUNDATION=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --workspace-url) WORKSPACE_URL="$2"; shift 2 ;;
        --target-dir) TARGET_DIR="$2"; shift 2 ;;
        --run-foundation) RUN_FOUNDATION=true; shift ;;
        -h|--help)
            echo "Usage: ./setup.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --workspace-url URL    Databricks workspace URL"
            echo "  --target-dir PATH      Target directory in workspace (default: /Workspace/Users/<you>/Genie_Family_PoC)"
            echo "  --run-foundation       Run Notebook 1 after upload to create synthetic data"
            echo "  -h, --help             Show this help"
            exit 0
            ;;
        *) echo "Unknown option: $1"; exit 1 ;;
    esac
done

echo "============================================================"
echo "🏭 Genie Family PoC — Automated Setup"
echo "============================================================"
echo ""
echo "📂 Target directory: $TARGET_DIR"
echo ""

# Check Databricks CLI
if ! command -v databricks &> /dev/null; then
    echo "❌ Databricks CLI not found. Install with: pip install databricks-cli"
    exit 1
fi
echo "✅ Databricks CLI found"

# Create target directory
echo ""
echo "📁 Creating workspace directory..."
databricks workspace mkdirs "$TARGET_DIR" 2>/dev/null || true
databricks workspace mkdirs "$TARGET_DIR/notebooks" 2>/dev/null || true

# Upload notebooks
echo ""
echo "📤 Uploading notebooks..."
NOTEBOOK_DIR="$(dirname "$0")/notebooks"

for notebook in "$NOTEBOOK_DIR"/*.ipynb; do
    filename=$(basename "$notebook")
    echo "   Uploading: $filename"
    databricks workspace import "$notebook" "$TARGET_DIR/notebooks/$filename" \
        --format JUPYTER --overwrite 2>/dev/null || \
    databricks workspace import "$notebook" "$TARGET_DIR/notebooks/$filename" \
        --format AUTO --overwrite
done

echo ""
echo "✅ All notebooks uploaded successfully!"
echo ""
echo "============================================================"
echo "📋 NEXT STEPS"
echo "============================================================"
echo ""
echo "1. Open your workspace and navigate to:"
echo "   $TARGET_DIR/notebooks/"
echo ""
echo "2. Run the notebooks in order:"
echo "   01_Foundation_Synthetic_Data_Setup.ipynb    (~5 min)"
echo "   02_Genie_Agent_Setup_Curation.ipynb         (~10 min)"
echo "   03_Genie_One_Business_User_Experience.ipynb  (~5 min)"
echo "   04_Genie_Code_Technical_Demos.ipynb          (~10 min)"
echo "   05_Genie_Mobile_Setup_Demo_Guide.ipynb       (~5 min)"
echo ""
echo "3. Requirements:"
echo "   - DBR 14.0+ cluster or Serverless"
echo "   - Unity Catalog enabled"
echo "   - Partner-Powered AI enabled"
echo "   - CREATE CATALOG permission"
echo ""
echo "============================================================"

# Optionally run the foundation notebook
if [ "$RUN_FOUNDATION" = true ]; then
    echo ""
    echo "🚀 Running Foundation notebook to create synthetic data..."
    databricks jobs submit --json '{
        "run_name": "Genie PoC Foundation Setup",
        "tasks": [{
            "task_key": "foundation",
            "notebook_task": {
                "notebook_path": "'"$TARGET_DIR/notebooks/01_Foundation_Synthetic_Data_Setup"'"
            },
            "new_cluster": {
                "spark_version": "14.3.x-scala2.12",
                "num_workers": 0,
                "node_type_id": "i3.xlarge"
            }
        }]
    }'
    echo "✅ Foundation job submitted. Check the Jobs UI for status."
fi
