#!/bin/bash
# Shared library: environment variables, config helpers

export PIIXIDENT_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/quickshell"
export PIIXIDENT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/quickshell-wallpaper-picker"
export PIIXIDENT_RUNTIME="${XDG_RUNTIME_DIR:-/tmp}/quickshell-wallpaper-picker"
export PIIXIDENT_CFG="$PIIXIDENT_CONFIG/data/config.json"

mkdir -p "$PIIXIDENT_RUNTIME" 2>/dev/null
mkdir -p "$PIIXIDENT_CACHE" 2>/dev/null
mkdir -p "$PIIXIDENT_CACHE/wallpaper" 2>/dev/null

[ -f "$PIIXIDENT_CACHE/wallpaper/tags.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper/tags.json"
[ -f "$PIIXIDENT_CACHE/wallpaper/colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper/colors.json"
[ -f "$PIIXIDENT_CACHE/wallpaper/matugen-colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper/matugen-colors.json"

cfg_get() {
  local val
  val=$(jq -r "$1" "$PIIXIDENT_CFG" 2>/dev/null)
  [ "$val" = "null" ] && val=""
  echo "${val/#\~/$HOME}"
}

require_cmd() {
  local missing=()
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || missing+=("$cmd")
  done
  if [ ${#missing[@]} -gt 0 ]; then
    echo "missing required commands: ${missing[*]}" >&2
    return 1
  fi
}

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}
