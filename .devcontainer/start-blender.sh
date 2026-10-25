#!/bin/bash
# Start Blender with MCP addon in background
xvfb-run -a blender -b --python-expr "
import bpy
bpy.ops.wm.addon_enable(module='blender_mcp')
bpy.ops.blender_mcp.start_server()
print('Blender MCP addon started on port 9876')
" &
BLENDER_PID=$!
echo "Blender started with PID: $BLENDER_PID"
echo "Waiting for addon to be ready..."
sleep 10
echo "Blender should be ready. MCP addon listening on port 9876"
wait $BLENDER_PID