#!/usr/bin/env bash

XPANEL_SYSTEM="unknown"
XPANEL_REPO="unknown"
XPANEL_VERSION="0.1.0-dev"
XPANEL_LANGUAGE="${XPANEL_LANG:-es}"

xpanel_load_context() {
  local marker="$XPANEL_ROOT/xpanel"
  local system_file="$XPANEL_ROOT/scripts/xpanel-system.sh"

  if [[ ! -f "$marker" && -f "$system_file" ]]; then
    # shellcheck source=/dev/null
    source "$system_file"
    xpanel_write_marker "${SYSTEM:-unknown}" "${REPO:-unknown}" "${VERSION:-0.1.0-dev}" "${XPANEL_FILE_LANGUAGE:-${XPANEL_LANG:-es}}"
  fi

  if [[ -f "$marker" ]]; then
    # shellcheck source=/dev/null
    source "$marker"
  fi

  XPANEL_SYSTEM="${SYSTEM:-$XPANEL_SYSTEM}"
  XPANEL_REPO="${REPO:-$XPANEL_REPO}"
  XPANEL_VERSION="${VERSION:-$XPANEL_VERSION}"
  XPANEL_LANGUAGE="${XPANEL_FILE_LANGUAGE:-$XPANEL_LANGUAGE}"

  local language_file=""
  case "$XPANEL_SYSTEM" in
    xpanel-vps) language_file=/var/lib/xpanel-vps/language ;;
    xpanel-host) language_file=/var/lib/xpanel-host/language ;;
  esac
  if [[ -n "$language_file" && -f "$language_file" && ! -L "$language_file" ]]; then
    local saved_language
    saved_language="$(tr -d '\r\n' < "$language_file")"
    [[ "$saved_language" == es || "$saved_language" == en ]] && XPANEL_LANGUAGE="$saved_language"
  fi

  if [[ "$XPANEL_SYSTEM" == "unknown" ]]; then
    if [[ -f "$XPANEL_ROOT/scripts/install-vps.sh" ]] || [[ -f "$XPANEL_ROOT/scripts/xpanel-vps-install.sh" ]]; then
      XPANEL_SYSTEM="xpanel-vps"
    elif [[ -f "$XPANEL_ROOT/artisan" ]]; then
      XPANEL_SYSTEM="xpanel-host"
    elif [[ -f "$XPANEL_ROOT/go.mod" ]] && grep -q "xpanel-vm" "$XPANEL_ROOT/go.mod"; then
      XPANEL_SYSTEM="xpanel-vm"
    fi
  fi

  case "$XPANEL_LANGUAGE" in
    en*) XPANEL_LANGUAGE="en" ;;
    *) XPANEL_LANGUAGE="es" ;;
  esac
}

xpanel_t() {
  local key="$1"
  shift || true
  local value="${XPANEL_I18N[$key]:-$key}"

  while [[ $# -gt 0 ]]; do
    local pair="$1"
    local name="${pair%%=*}"
    local replacement="${pair#*=}"
    value="${value//:$name/$replacement}"
    shift
  done

  printf '%s' "$value"
}

xpanel_load_language() {
  local lang_file="$XPANEL_CLI_DIR/lang/$XPANEL_LANGUAGE.sh"
  if [[ ! -f "$lang_file" ]]; then
    lang_file="$XPANEL_CLI_DIR/lang/es.sh"
  fi

  # shellcheck source=/dev/null
  source "$lang_file"
}

xpanel_save_language() {
  local new_language="$1"
  local state_dir
  case "$XPANEL_SYSTEM" in
    xpanel-vps) state_dir=/var/lib/xpanel-vps ;;
    xpanel-host) state_dir=/var/lib/xpanel-host ;;
    *) xpanel_write_marker "$XPANEL_SYSTEM" "$XPANEL_REPO" "$XPANEL_VERSION" "$new_language"; return ;;
  esac
  [[ ! -L "$state_dir" && ! -L "$state_dir/language" ]] || return 1
  install -d -o root -g root -m 0755 "$state_dir"
  printf '%s\n' "$new_language" > "$state_dir/language"
  chmod 0644 "$state_dir/language"
}

xpanel_write_marker() {
  local system="$1"
  local repo="$2"
  local version="$3"
  local language="$4"
  local marker="$XPANEL_ROOT/xpanel"

  cat > "$marker" <<EOF
SYSTEM="$system"
REPO="$repo"
VERSION="$version"
XPANEL_FILE_LANGUAGE="$language"
EOF
}

xpanel_load_context
xpanel_load_language
