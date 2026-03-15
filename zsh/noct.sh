#!/usr/bin/env bash

STATE_FILE="/tmp/noctalia_wallpaper_toggle_last_run"
COOLDOWN=3

now=$(date +%s.%N)

if [[ -f "$STATE_FILE" ]]; then
  last=$(cat "$STATE_FILE")
  diff=$(awk "BEGIN {print $now - $last}")
  if (($(awk "BEGIN {print ($diff < $COOLDOWN)}"))); then
    exit 0
  fi
fi

echo "$now" >"$STATE_FILE"
noctalia-shell ipc call wallpaper toggle
