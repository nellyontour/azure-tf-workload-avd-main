# How to open and edit the architecture diagram

The `architecture.drawio` file in this folder is a [draw.io](https://app.diagrams.net/) diagram.

## Opening the diagram

**Option A — VS Code (recommended)**

Install the [Draw.io Integration](https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio) extension, then open the file directly in VS Code.

**Option B — Browser**

1. Go to [app.diagrams.net](https://app.diagrams.net/)
2. Click **Open Existing Diagram**
3. Select `architecture.drawio` from this folder

## Editing guidelines

- Keep the diagram in the draw.io XML format (`.drawio`) — do not convert to PNG/SVG as the source of truth
- Export a PNG for embedding in documentation: **File → Export As → PNG** (resolution: 2x)
- Commit both the `.drawio` source and any exported images
- `.drawio.bkp` and `.drawio.dtmp` files are git-ignored

## Template structure

The template includes:
- A title block (update with workload name and date)
- Placeholder shapes for Azure resources (subscription, resource group, VNet, workload)
- A legend

Replace the placeholders with your actual architecture.
