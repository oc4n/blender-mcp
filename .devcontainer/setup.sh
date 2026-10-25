#!/bin/bash
set -e

echo "🔧 Setting up Blender MCP in Codespace..."

# Install dependencies
apt-get update && apt-get install -y \
    wget \
    xvfb \
    libgl1-mesa-glx \
    libglib2.0-0 \
    python3-pip \
    python3-venv \
    git \
    curl

# Install Blender (latest stable)
BLENDER_VERSION="4.2.3"
BLENDER_URL="https://download.blender.org/release/Blender4.2/blender-${BLENDER_VERSION}-linux-x64.tar.xz"
echo "📥 Downloading Blender ${BLENDER_VERSION}..."
wget -q "${BLENDER_URL}" -O /tmp/blender.tar.xz
tar -xf /tmp/blender.tar.xz -C /opt
mv /opt/blender-* /opt/blender
ln -sf /opt/blender/blender /usr/local/bin/blender
rm /tmp/blender.tar.xz

# Verify Blender install
blender --version

# Install uv (Python package manager)
curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
export PATH="$HOME/.local/bin:$PATH"

# Install the blender-mcp package in development mode
cd /workspaces/blender-mcp
uv sync --frozen

# Install the Blender addon
echo "🔌 Installing Blender MCP addon..."
python -m blender_mcp.cli install-addon

echo "✅ Setup complete!"
echo ""
echo "📋 To run Blender MCP:"
echo "  1. Start Blender with the addon (in one terminal):"
echo "     xvfb-run -a blender -b --python-expr \"import bpy; bpy.ops.wm.addon_enable(module='blender_mcp'); bpy.ops.blender_mcp.start_server()\""
echo ""
echo "  2. Run the MCP server (in another terminal):"
echo "     python main.py"
echo ""
echo "🔗 The addon listens on port 9876 (forwarded by Codespaces)"
echo "   Use the forwarded URL in your OpenCode MCP config"