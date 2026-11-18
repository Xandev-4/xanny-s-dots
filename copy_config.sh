#!/usr/bin/env bash
set -e

# Backs up the config dir

BACKUP_DIR="$HOME/dotfiles-stow"
DIR="$HOME/.config"
CONFIGS=(
  # compositor & UI
  "niri"
  "waybar"
  "swaync"
  "swayosd"
  "fuzzel"
  "rofi"
  "dunst"
  "ags"
  # theming
  "matugen"
  "gtk-3.0"
  "gtk-4.0"
  "qt5ct"
  "qt6ct"
  "Kvantum"
  # shell & editors
  "fish"
  "starship.toml"
  "kitty"
  "alacritty"
  "nvim"
  "micro"
  # cli & media
  "yazi"
  "mpd"
  "rmpc"
  "cava"
  "fastfetch"
  "btop"
  "nomacs"
  "wayvibes"
  # system & glue
  "systemd"
  "mimeapps.list"
  "user-dirs.dirs"
  "dolphinrc"
  "xdg-desktop-portal"
  "wireplumber"
  )

for item in "${CONFIGS[@]}"; do
  mkdir -p "$BACKUP_DIR/$item/.config"
  cp -r "$DIR/$item" "$BACKUP_DIR/$item/.config/"
done

# -------------------------------------------------------

# Backs up the hidden home files

HID_CONFIG=(
  ".gitconfig"
  ".bashrc"
  ".bash_profile"
  )

for item in "${HID_CONFIG[@]}"; do
  pkg="${item#.}"
  mkdir -p "$BACKUP_DIR/$pkg"
  cp -r "$HOME/$item" "$BACKUP_DIR/$pkg/"
done

# -------------------------------------------------------

# Backs up installed packages

mkdir -p "$BACKUP_DIR/packages"
pacman -Qqen > "$BACKUP_DIR/packages/pkglist-native.txt"
pacman -Qqem > "$BACKUP_DIR/packages/pkglist-foreign.txt"

# -------------------------------------------------------

# Deletes unnecessary files

rm -rf "$BACKUP_DIR/fish/.config/fish/fish_history" "$BACKUP_DIR/fish/.config/fish/fish_variables"
