#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

echo "$(xpanel_t title system="$XPANEL_SYSTEM")"
echo
echo "$(xpanel_t commands)"
echo "  help       $(xpanel_t cmd_help)"
echo "  version    $(xpanel_t cmd_version)"
echo "  status     $(xpanel_t cmd_status)"
echo "  instances  Manage isolated XPanel Host instances (xpanel-vps)"
echo "  language   $(xpanel_t cmd_language)"
echo "  git        $(xpanel_t cmd_git)"
echo "  update     $(xpanel_t cmd_update)"
echo "  serve      $(xpanel_t cmd_serve)"
echo "  uninstall  $(xpanel_t cmd_uninstall)"
