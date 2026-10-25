#!/bin/bash
# Start the MCP server (connects to Blender on localhost:9876)
cd /workspaces/blender-mcp
source $HOME/.local/bin/env
export PATH="$HOME/.local/bin:$PATH"
python main.py