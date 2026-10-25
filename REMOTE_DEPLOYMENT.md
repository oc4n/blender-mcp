# Blender MCP - Remote Deployment Guide

## The Architecture

```
┌─────────────────┐     TCP 9876      ┌──────────────────┐
│  MCP Server     │ ────────────────▶ │  Blender + Addon │
│  (Python)       │                   │  (Running Blender)│
└─────────────────┘                   └──────────────────┘
     ▲                                        ▲
     │                                        │
     │ MCP Protocol                           │ bpy API
     │                                        │
┌─────────────────┐                   ┌──────────────────┐
│  OpenCode /     │                   │  Your 3D Scene   │
│  Claude / etc   │                   │                  │
└─────────────────┘                   └──────────────────┘
```

**Critical**: Blender MUST run somewhere with the addon installed. The MCP server is just a bridge.

---

## Free Cloud Options (No Local Hosting)

### 1. GitHub Codespaces (Easiest, 60 hrs/month free)

**Setup:**
1. Push this repo to your GitHub
2. Open in Codespaces (`.` → "Open in Codespaces")
3. Wait for devcontainer to build (~5-10 min)
4. Run in terminal 1: `bash .devcontainer/start-blender.sh`
5. Run in terminal 2: `bash .devcontainer/start-mcp.sh`
6. Codespaces forwards port 9876 → gives you a public URL like `https://xxx-9876.app.github.dev`

**Use in OpenCode:**
```json
{
  "mcp": {
    "servers": {
      "blender": {
        "url": "https://your-codespace-9876.app.github.dev"
      }
    }
  }
}
```

---

### 2. Oracle Cloud Free Tier (Always Free, More Power)

**Setup:**
1. Sign up at cloud.oracle.com (always free ARM VM: 4 CPU, 24GB RAM)
2. Create VM instance (Ubuntu 22.04, ARM shape)
3. SSH in and run:
```bash
# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
newgrp docker

# Clone and deploy
git clone https://github.com/YOUR_USERNAME/blender-mcp.git
cd blender-mcp
docker-compose up -d
```
4. Open port 9876 in Oracle Cloud security lists
5. Use `http://YOUR_VM_IP:9876` in OpenCode

---

### 3. Google Cloud Run (Free tier, but complex for Blender)

Not recommended - Blender needs persistent compute, Cloud Run is request-based.

---

### 4. Railway / Render (Free tier, container support)

**Railway:**
1. Connect GitHub repo to Railway
2. Add Dockerfile (already in repo)
3. Set environment variables:
   - `BLENDER_HOST=blender` (if using docker-compose)
   - Or run Blender separately
4. Railway gives you `https://your-app.railway.app`

**Render:**
1. Connect GitHub repo
2. Create "Web Service" from Docker
3. Similar to Railway

---

## Recommended: GitHub Codespaces (Start Here)

### Step-by-Step:

1. **Create GitHub repo:**
   ```bash
   cd C:\Users\TUFF\Python\blender-mcp
   git init
   git add .
   git commit -m "Initial commit"
   gh repo create blender-mcp --public --source=. --push
   ```

2. **Open in Codespaces:**
   - Go to your repo on GitHub
   - Click `<> Code` → `Codespaces` → `Create codespace on main`
   - Wait for build (5-10 min)

3. **Start Blender (Terminal 1):**
   ```bash
   bash .devcontainer/start-blender.sh
   ```

4. **Start MCP Server (Terminal 2):**
   ```bash
   bash .devcontainer/start-mcp.sh
   ```

5. **Get the forwarded URL:**
   - Codespaces shows "Ports" tab
   - Port 9876 → copy the URL (e.g., `https://witty-space-xyz-9876.app.github.dev`)

6. **Configure OpenCode:**
   Create `~/.config/opencode/opencode.json`:
   ```json
   {
     "$schema": "https://opencode.ai/config.json",
     "mcp": {
       "servers": {
         "blender": {
           "url": "https://YOUR_CODESPACE_URL"
         }
       }
     }
   }
   ```

7. **Test in OpenCode:**
   - Run `opencode` 
   - Ask: "Check Blender addon status"
   - Should work!

---

## Important Notes

| Aspect | Details |
|--------|---------|
| **Blender must run** | The MCP server alone does nothing - it needs Blender |
| **Port 9876** | Addon listens here; MCP server connects here |
| **Codespaces timeout** | Stops after 30 min inactivity; restart to resume |
| **Oracle Cloud** | Best for "always on" free hosting |
| **Data persistence** | Blender files saved in container; use volumes for persistence |

---

## Troubleshooting

**Connection refused:**
- Blender not started or addon not enabled
- Check `start-blender.sh` ran without errors
- Verify port 9876 is forwarded/open

**Addon version mismatch:**
- Run `python -m blender_mcp.cli install-addon` in Codespace
- Restart Blender

**Codespaces URL changes:**
- Each session gets new URL
- Update OpenCode config each time
- Or use Oracle Cloud for stable IP

---

## Next Steps

1. Push to GitHub
2. Open Codespace
3. Run both start scripts
4. Copy forwarded URL
5. Add to OpenCode config
6. Start using Blender via MCP!

Would you like me to help you push to GitHub and open the Codespace?