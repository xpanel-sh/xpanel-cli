#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_ROOT="$(mktemp -d)"
trap 'rm -rf -- "$TEMP_ROOT"' EXIT

mkdir -p "$TEMP_ROOT/product/scripts"
cat > "$TEMP_ROOT/product/xpanel" <<'EOF'
SYSTEM="xpanel-host"
REPO="github.com/xpanel-sh/xpanel-host"
VERSION="test"
XPANEL_FILE_LANGUAGE="es"
EOF

cli_command="$ROOT/bin/xpanel"
if [[ "$(uname -s)" == "Linux" ]]; then
  ln -s "$ROOT/bin/xpanel" "$TEMP_ROOT/xpanel"
  cli_command="$TEMP_ROOT/xpanel"
fi
output="$(cd "$TEMP_ROOT" && XPANEL_DEFAULT_ROOT="$TEMP_ROOT/product" "$cli_command" status)"
grep -q 'xpanel-host' <<< "$output"
grep -q "$TEMP_ROOT/product" <<< "$output"

echo "xpanel global command smoke test passed."
