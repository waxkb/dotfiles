#!/bin/bash
# Launcher for standalone wallpaper picker

export PIIXIDENT_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/piixident"
export PIIXIDENT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/piixident"

# Ensure cache directories exist
mkdir -p "$PIIXIDENT_CACHE/wallpaper-standalone/thumbs" 2>/dev/null
mkdir -p "$PIIXIDENT_CACHE/wallpaper-standalone/we-thumbs" 2>/dev/null
mkdir -p "$PIIXIDENT_CACHE/wallpaper-standalone/video-thumbs" 2>/dev/null

# Seed cache files
[ -f "$PIIXIDENT_CACHE/colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/colors.json"
[ -f "$PIIXIDENT_CACHE/wallpaper-standalone/tags.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper-standalone/tags.json"
[ -f "$PIIXIDENT_CACHE/wallpaper-standalone/colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper-standalone/colors.json"
[ -f "$PIIXIDENT_CACHE/wallpaper-standalone/matugen-colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper-standalone/matugen-colors.json"

exec quickshell --no-duplicate --path "$HOME/.config/quickshell/wallpaper-picker-standalone"
