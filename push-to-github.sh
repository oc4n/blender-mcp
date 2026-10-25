#!/bin/bash
# Quick push to GitHub and open Codespace

set -e

REPO_NAME="blender-mcp"
GITHUB_USER=$(gh api user --jq .login 2>/dev/null || echo "")

if [ -z "$GITHUB_USER" ]; then
    echo "❌ GitHub CLI not authenticated. Run: gh auth login"
    exit 1
fi

echo "📤 Pushing to GitHub..."
cd /workspaces/blender-mcp 2>/dev/null || cd C:\Users\TUFF\Python\blender-mcp

git init 2>/dev/null || true
git add .
git commit -m "Blender MCP for remote deployment" 2>/dev/null || true

# Create repo if not exists
gh repo create "$REPO_NAME" --public --source=. --push --yes 2>/dev/null || \
    git push -u origin main

echo "✅ Pushed to https://github.com/$GITHUB_USER/$REPO_NAME"
echo ""
echo "🚀 Opening Codespace..."
gh codespace create --repo "$GITHUB_USER/$REPO_NAME" --web