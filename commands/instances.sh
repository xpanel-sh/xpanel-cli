#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

if [[ "$XPANEL_SYSTEM" != "xpanel-vps" ]]; then
  echo "The instances command is only available for xpanel-vps." >&2
  exit 1
fi

exec php "$XPANEL_ROOT/artisan" xpanel:instances "$@"
