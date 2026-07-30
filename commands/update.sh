#!/usr/bin/env bash
set -euo pipefail

source "$XPANEL_CLI_DIR/lib/context.sh"

update_repository() {
  local directory="$1" label="$2"

  if [[ ! -d "$directory/.git" ]]; then
    echo "$(xpanel_t update_not_git label="$label" root="$directory")" >&2
    return 1
  fi
  if [[ -n "$(git -C "$directory" status --porcelain --untracked-files=no)" ]]; then
    echo "$(xpanel_t update_dirty label="$label" root="$directory")" >&2
    return 1
  fi

  echo "$(xpanel_t update_fetching label="$label")"
  git -C "$directory" pull --ff-only
}

if [[ -d "$XPANEL_CLI_DIR/.git" ]]; then
  update_repository "$XPANEL_CLI_DIR" "xpanel-cli"
  bash "$XPANEL_CLI_DIR/install.sh"
else
  echo "$(xpanel_t update_cli_unmanaged root="$XPANEL_CLI_DIR")"
fi

update_repository "$XPANEL_ROOT" "$XPANEL_SYSTEM"

if [[ -f "$XPANEL_ROOT/scripts/xpanel-update.sh" ]]; then
  bash "$XPANEL_ROOT/scripts/xpanel-update.sh"
fi

echo "$(xpanel_t update_complete system="$XPANEL_SYSTEM")"
