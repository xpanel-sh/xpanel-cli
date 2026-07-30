#!/usr/bin/env bash
set -euo pipefail

if [[ -x "$XPANEL_ROOT/scripts/xpanel-serve.sh" ]]; then
  exec "$XPANEL_ROOT/scripts/xpanel-serve.sh"
fi

source "$XPANEL_CLI_DIR/lib/context.sh"

echo "$(xpanel_t serve_not_configured system="$XPANEL_SYSTEM")" >&2
exit 2
