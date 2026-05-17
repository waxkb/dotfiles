#!/usr/bin/env bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/wall"

# Ensure the binary exists and is executable
# If 'tofi' is not in your PATH, use the full path to the binary instead
TOFI_BIN="tofi"

# Generate the list of files from the directory and pipe to tofi
# tofi will filter them based on your typing
# The output of tofi is the selected file path
find "$WALLPAPER_DIR" -type f | $TOFI_BIN --config ~/.config/tofi/config | while read -r selection; do
  if [[ -f "$selection" ]]; then
    # Apply the wallpaper
    # Replace 'swww' with 'swaybg -i' or 'feh --bg-fill' as needed
    dms ipc call wallpaper set "$selection" || noctalia msg wallpaper-set "$selection" && matugen image "$selection" --scource-color-index 0
  fi
done
