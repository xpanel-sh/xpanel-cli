#!/usr/bin/env bash
set -Eeuo pipefail

CLI_SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TEMP_ROOT="$(mktemp -d)"
cleanup() {
  rm -rf -- "$TEMP_ROOT"
}
trap cleanup EXIT

git_seed() {
  local directory="$1"
  git -C "$directory" init -q -b stable
  git -C "$directory" config user.email tests@xpanel.local
  git -C "$directory" config user.name "XPanel tests"
  git -C "$directory" add .
  git -C "$directory" commit -qm initial
}

cli_seed="$TEMP_ROOT/cli-seed"
mkdir -p "$cli_seed"
cp -R "$CLI_SOURCE/." "$cli_seed/"
rm -rf -- "$cli_seed/.git"
git_seed "$cli_seed"
git clone -q --bare "$cli_seed" "$TEMP_ROOT/cli.git"
git clone -q --branch stable "$TEMP_ROOT/cli.git" "$TEMP_ROOT/xpanel-cli"

product_seed="$TEMP_ROOT/product-seed"
mkdir -p "$product_seed/scripts"
cat > "$product_seed/xpanel" <<'EOF'
SYSTEM="xpanel-host"
REPO="example.invalid/xpanel-host"
VERSION="test"
XPANEL_FILE_LANGUAGE="es"
EOF
cat > "$product_seed/scripts/xpanel-update.sh" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
touch "$XPANEL_ROOT/update-ran"
EOF
chmod +x "$product_seed/scripts/xpanel-update.sh"
git_seed "$product_seed"
git clone -q --bare "$product_seed" "$TEMP_ROOT/product.git"
git clone -q --branch stable "$TEMP_ROOT/product.git" "$TEMP_ROOT/xpanel-host"

XPANEL_BIN_DIR="$TEMP_ROOT/bin" \
  "$TEMP_ROOT/xpanel-cli/bin/xpanel" update --root="$TEMP_ROOT/xpanel-host" >/dev/null
test -e "$TEMP_ROOT/bin/xpanel"
test -f "$TEMP_ROOT/xpanel-host/update-ran"

printf '\n# local change\n' >> "$TEMP_ROOT/xpanel-host/xpanel"
if XPANEL_BIN_DIR="$TEMP_ROOT/bin" \
  "$TEMP_ROOT/xpanel-cli/bin/xpanel" update --root="$TEMP_ROOT/xpanel-host" >/dev/null 2>&1; then
  echo "Update should refuse a product with tracked local changes." >&2
  exit 1
fi

echo "xpanel update smoke test passed."
