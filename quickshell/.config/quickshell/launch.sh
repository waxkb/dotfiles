#!/bin/bash
# Launcher for standalone wallpaper picker

export PIIXIDENT_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/piixident"
export PIIXIDENT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/piixident"

# Ensure cache directories exist
mkdir -p "$PIIXIDENT_CACHE/wallpaper/thumbs" 2>/dev/null
mkdir -p "$PIIXIDENT_CACHE/wallpaper/we-thumbs" 2>/dev/null
mkdir -p "$PIIXIDENT_CACHE/wallpaper/video-thumbs" 2>/dev/null

# Seed cache files
[ -f "$PIIXIDENT_CACHE/colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/colors.json"
[ -f "$PIIXIDENT_CACHE/wallpaper/tags.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper/tags.json"
[ -f "$PIIXIDENT_CACHE/wallpaper/colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper/colors.json"
[ -f "$PIIXIDENT_CACHE/wallpaper/matugen-colors.json" ] || echo '{}' > "$PIIXIDENT_CACHE/wallpaper/matugen-colors.json"

exec quickshell --no-duplicate --path "$HOME/.config/quickshell"
