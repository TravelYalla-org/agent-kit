#!/usr/bin/env bash
# Builds the ZIP for the ChatGPT / Codex plugin submission portal.
#
#   scripts/build-chatgpt-zip.sh [portal-plugin-name]
#
# The portal only accepts an update whose manifest `name` matches the plugin it
# already has. Ours was first created from the MCP connector, so the portal
# knows it by a generated ID rather than `travelyalla`. The ID is applied to the
# ZIP's copy of plugin.json only; the repo keeps `travelyalla` for Claude Code
# and Codex marketplace installs.
#
# Claude-only files (.claude-plugin/, .mcp.json) are left out.
set -euo pipefail

PORTAL_NAME="${1:-dev-6abd1a1153b48191bd48f35602a19139}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$ROOT/plugins/travelyalla"
VERSION="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$PLUGIN/plugin.json")"
OUT="$ROOT/dist/travelyalla-$VERSION.zip"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cp -R "$PLUGIN/." "$STAGE/"
rm -rf "$STAGE/.claude-plugin" "$STAGE/.mcp.json"
find "$STAGE" -name .DS_Store -delete

python3 - "$STAGE/plugin.json" "$PORTAL_NAME" <<'EOF'
import json, sys
path, name = sys.argv[1], sys.argv[2]
manifest = json.load(open(path))
manifest["name"] = name
with open(path, "w") as f:
    json.dump(manifest, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF

mkdir -p "$ROOT/dist"
rm -f "$OUT"
(cd "$STAGE" && zip -qr "$OUT" .)
echo "$OUT (name: $PORTAL_NAME, version: $VERSION)"
