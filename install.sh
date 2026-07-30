#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="${XPANEL_CLI_DIR:-/opt/xpanel-cli}"
BIN_DIR="${XPANEL_BIN_DIR:-/usr/local/bin}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

INSTALL_DIR="$(realpath -m "$INSTALL_DIR")"
BIN_DIR="$(realpath -m "$BIN_DIR")"
if [[ ! "$INSTALL_DIR" =~ ^/[^/]+/[^/]+ ]] || [[ "$(basename "$INSTALL_DIR")" != "xpanel-cli" ]]; then
  echo "Unsafe xpanel CLI install directory: $INSTALL_DIR" >&2
  exit 1
fi
if [[ ! "$BIN_DIR" =~ ^/[^/]+/[^/]+ ]]; then
  echo "Unsafe xpanel CLI binary directory: $BIN_DIR" >&2
  exit 1
fi

install -d "$INSTALL_DIR"
install -d "$BIN_DIR"

if [[ "$(realpath "$SCRIPT_DIR")" != "$(realpath "$INSTALL_DIR")" ]]; then
  rm -rf "$INSTALL_DIR/bin" "$INSTALL_DIR/commands" "$INSTALL_DIR/lib" "$INSTALL_DIR/lang"
  cp -R "$SCRIPT_DIR/bin" "$INSTALL_DIR/"
  cp -R "$SCRIPT_DIR/commands" "$INSTALL_DIR/"
  cp -R "$SCRIPT_DIR/lib" "$INSTALL_DIR/"
  cp -R "$SCRIPT_DIR/lang" "$INSTALL_DIR/"
fi

chmod +x "$INSTALL_DIR/bin/xpanel"
find "$INSTALL_DIR/commands" -type f -name "*.sh" -exec chmod +x {} \;

ln -sf "$INSTALL_DIR/bin/xpanel" "$BIN_DIR/xpanel"
[[ -x "$BIN_DIR/xpanel" ]] || { echo "Could not install the global xpanel command." >&2; exit 1; }

echo "xpanel CLI installed at $INSTALL_DIR"
echo "Global command: $BIN_DIR/xpanel"
echo "Run: xpanel language es | en"
