#!/usr/bin/env bash

# ------------------------------
# Minimal Wallpaper Picker
# Dependencies: rofi, imagemagick
# Wallpaper setting handled by desktop shell (dms)
# ------------------------------

# === USER CONFIG ===
WIDTH=360
HEIGHT=360

WALL_DIR="$HOME/wall"
CACHE_DIR="$HOME/.cache/wall_thumbs"
ROFI_THEME="$HOME/.config/rofi/applets/wallSelect.rasi"
# ===================

mkdir -p "$CACHE_DIR"

# Generate thumbnails (only if missing)
for img in "$WALL_DIR"/*.{jpg,jpeg,png,webp,gif}; do
  [ -f "$img" ] || continue

  thumb="$CACHE_DIR/$(basename "$img")"
  [ -f "$thumb" ] ||
    magick "$img" -resize "${WIDTH}x${HEIGHT}^" -gravity center -crop "${WIDTH}x${HEIGHT}+0+0" +repage "$thumb"
done

# Kill rofi if already running
pkill rofi 2>/dev/null

# Build rofi menu
SELECTION=$(
  find "$WALL_DIR" -maxdepth 1 -type f \
    \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.gif" \) |
    sort |
    while read -r img; do
      name=$(basename "$img")
      printf "%s\x00icon\x1f%s/%s\n" "$name" "$CACHE_DIR" "$name"
    done |
    rofi -dmenu -i -matching fuzzy -p "" -show-icons \
      -theme "$ROFI_THEME"
)

# Set wallpaper via desktop shell
if [ -n "$SELECTION" ]; then
  dms ipc call wallpaper set "$WALL_DIR/$SELECTION"
fi
