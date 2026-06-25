WALLPAPER_DIR="$HOME/nixos/wall"
TOFI_BIN="tofi"

selection=$($TOFI_BIN --config ~/.config/tofi/config < <(find "$WALLPAPER_DIR" -type f))

if [[ -f "$selection" ]]; then
  matugen image "$selection" --source-color-index 0 &
  noctalia msg wallpaper-set "$selection" &
  dms ipc call wallpaper set "$selection" &

  wait
fi
