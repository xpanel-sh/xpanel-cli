#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

echo "$(xpanel_t system): $XPANEL_SYSTEM"
echo "$(xpanel_t repo): $XPANEL_REPO"
echo "$(xpanel_t version): $XPANEL_VERSION"
echo "$(xpanel_t language): $XPANEL_LANGUAGE"
echo "$(xpanel_t root): $XPANEL_ROOT"

