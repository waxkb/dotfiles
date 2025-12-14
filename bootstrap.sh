#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

cd "$DOTFILES_DIR"

packages=(
  btop
  cava
  clipse
  dconf
  fastfetch
  hypr
  kitty
  mako
  matugen
  niri
  nvim
  rofi
  spicetify
  spotify
  vesktop
  waybar
  waypaper
  yay
  yazi
)

stow --target="$HOME" "${packages[@]}"
