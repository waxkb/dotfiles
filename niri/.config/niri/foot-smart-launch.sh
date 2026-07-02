#!/usr/bin/env bash
set -euo pipefail

cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/foot-cwd"
mkdir -p "$cache_dir"

app_id=""
if json="$(niri msg --json focused-window 2>/dev/null)"; then
  app_id="$(printf '%s' "$json" | jq -r '.app_id // ""')"
fi

if [[ "$app_id" == footclient-* ]]; then
  token="${app_id#footclient-}"
  cwd_file="$cache_dir/$token"
  if [[ -r "$cwd_file" ]]; then
    cwd="$(<"$cwd_file")"
    if [[ -d "$cwd" ]]; then
      token="$(cat /proc/sys/kernel/random/uuid)"
      exec env FOOT_CWD_TOKEN="$token" footclient -E --app-id "footclient-$token" --working-directory "$cwd" "$@"
    fi
  fi
fi

token="$(cat /proc/sys/kernel/random/uuid)"
exec env FOOT_CWD_TOKEN="$token" footclient -E --app-id "footclient-$token" "$@"
