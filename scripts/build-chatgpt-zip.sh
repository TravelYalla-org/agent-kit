#!/usr/bin/env bash
# Builds the ZIP for the ChatGPT / Codex plugin portal.
#
#   scripts/build-chatgpt-zip.sh            # update the existing workspace plugin
#   scripts/build-chatgpt-zip.sh directory  # public directory submission ("With MCP")
#
# workspace: the plugin was first created from the MCP connector, so the portal
#   knows it by a generated ID and accepts an update only when the manifest
#   `name` is that ID and `.app.json` references exactly its registered
#   connector. The bundled mcp.json is replaced by that reference.
# directory: keeps mcp.json; the portal's "With MCP" flow registers the server
#   and does not accept `.app.json` references.
#
# Both modes leave out the Claude-only files (.claude-plugin/, .mcp.json).
set -euo pipefail

MODE="${1:-workspace}"
APP_SUFFIX="6abd1a1153b48191bd48f35602a19139"   # from chatgpt.com/plugins/plugin_asdk_app_<suffix>
PORTAL_NAME="dev-$APP_SUFFIX"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGIN="$ROOT/plugins/travelyalla"
VERSION="$(python3 -c 'import json,sys; print(json.load(open(sys.argv[1]))["version"])' "$PLUGIN/plugin.json")"
OUT="$ROOT/dist/travelyalla-$VERSION-$MODE.zip"

STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT

cp -R "$PLUGIN/." "$STAGE/"
rm -rf "$STAGE/.claude-plugin" "$STAGE/.mcp.json"
find "$STAGE" -name .DS_Store -delete

case "$MODE" in
workspace)
  rm "$STAGE/mcp.json"
  cat > "$STAGE/.app.json" <<EOF
{
  "apps": {
    "$PORTAL_NAME": {
      "id": "asdk_app_$APP_SUFFIX"
    }
  }
}
EOF
  python3 - "$STAGE/plugin.json" "$PORTAL_NAME" <<'EOF'
import json, sys
path, name = sys.argv[1], sys.argv[2]
manifest = json.load(open(path))
manifest["name"] = name
openai = manifest["extensions"]["com.openai"]
openai["apps"] = "./.app.json"
# Review test cases are for directory submission and must be tied to exactly
# one bundled MCP server; a connector reference doesn't count as one.
openai.pop("review", None)
with open(path, "w") as f:
    json.dump(manifest, f, indent=2, ensure_ascii=False)
    f.write("\n")
EOF
  ;;
directory) ;;
*)
  echo "usage: $0 [workspace|directory]" >&2
  exit 2
  ;;
esac

mkdir -p "$ROOT/dist"
rm -f "$OUT"
(cd "$STAGE" && zip -qr "$OUT" .)
echo "$OUT"
