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

output="$(cd "$TEMP_ROOT" && XPANEL_DEFAULT_ROOT="$TEMP_ROOT/product" "$ROOT/bin/xpanel" status)"
grep -q 'xpanel-host' <<< "$output"
grep -q "$TEMP_ROOT/product" <<< "$output"

echo "xpanel global command smoke test passed."
