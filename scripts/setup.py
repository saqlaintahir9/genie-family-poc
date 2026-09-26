#!/usr/bin/env python3
"""
Genie Family PoC — Python Setup Script
Cross-platform alternative to setup.sh

Usage:
    pip install databricks-sdk
    python setup.py --workspace-url https://your-workspace.cloud.databricks.com --token dapi...
"""

import argparse
import os
import sys
import json

def main():
    parser = argparse.ArgumentParser(description="Upload Genie Family PoC notebooks to Databricks")
    parser.add_argument("--workspace-url", required=True, help="Databricks workspace URL")
    parser.add_argument("--token", required=True, help="Databricks personal access token")
    parser.add_argument("--target-dir", default=None, help="Target directory in workspace")
    args = parser.parse_args()

    try:
        from databricks.sdk import WorkspaceClient
        from databricks.sdk.service.workspace import ImportFormat
    except ImportError:
        print("❌ databricks-sdk not installed. Run: pip install databricks-sdk")
        sys.exit(1)

    w = WorkspaceClient(host=args.workspace_url, token=args.token)

    # Get current user
    me = w.current_user.me()
    target_dir = args.target_dir or f"/Users/{me.user_name}/Genie_Family_PoC"

    print("=" * 60)
    print("🏭 Genie Family PoC — Python Setup")
    print("=" * 60)
    print(f"\n📂 Target: {target_dir}")
    print(f"👤 User: {me.user_name}")

    # Create directories
    try:
        w.workspace.mkdirs(target_dir)
        w.workspace.mkdirs(f"{target_dir}/notebooks")
    except Exception:
        pass

    # Upload notebooks
    notebook_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "notebooks")
    if not os.path.exists(notebook_dir):
        notebook_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), "notebooks")

    print("\n📤 Uploading notebooks...")
    for filename in sorted(os.listdir(notebook_dir)):
        if filename.endswith(".ipynb"):
            filepath = os.path.join(notebook_dir, filename)
            with open(filepath, "rb") as f:
                content = f.read()

            import base64
            target_path = f"{target_dir}/notebooks/{filename.replace('.ipynb', '')}"
            try:
                w.workspace.import_(
                    path=target_path,
                    content=base64.b64encode(content).decode(),
                    format=ImportFormat.JUPYTER,
                    overwrite=True
                )
                print(f"   ✅ {filename}")
            except Exception as e:
                print(f"   ❌ {filename}: {e}")

    print(f"\n{'=' * 60}")
    print("✅ Setup complete! Open your workspace and run the notebooks in order.")
    print(f"   {target_dir}/notebooks/")

if __name__ == "__main__":
    main()
