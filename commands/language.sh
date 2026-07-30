#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

NEW_LANGUAGE="${1:-}"

if [[ -z "$NEW_LANGUAGE" ]]; then
  echo "$(xpanel_t language_current language="$XPANEL_LANGUAGE")"
  echo "$(xpanel_t language_usage)"
  exit 0
fi

case "$NEW_LANGUAGE" in
  en*) NEW_LANGUAGE="en" ;;
  *) NEW_LANGUAGE="es" ;;
esac

xpanel_save_language "$NEW_LANGUAGE"
XPANEL_LANGUAGE="$NEW_LANGUAGE"
source "$XPANEL_CLI_DIR/lang/$XPANEL_LANGUAGE.sh"
echo "$(xpanel_t language_changed language="$NEW_LANGUAGE")"
