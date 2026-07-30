#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

echo "$(xpanel_t uninstall_safety)"
echo "$(xpanel_t system): $XPANEL_SYSTEM"
echo "$(xpanel_t root): $XPANEL_ROOT"
exit 2

