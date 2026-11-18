#!/usr/bin/env bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_REPO="https://github.com/Xandev-4/nvim.git"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

NATIVE_PKGS=(
    niri
    waybar
    swaync
    swayosd
    fuzzel
    rofi
    dunst
    matugen
    qt6ct
    kvantum
    fish
    starship
    kitty
    alacritty
    neovim
    tree-sitter-cli
    micro
    yazi
    ffmpegthumbnailer
    poppler-glib
    mpd
    mpc
    rmpc
    cava
    fastfetch
    btop
    dolphin
    git
    stow
    ttf-jetbrains-mono-nerd
    awesome-terminal-fonts
    noto-fonts-emoji
)

AUR_PKGS=(
    aylurs-gtk-shell-git
    nomacs
    wayvibes-git
    qt5ct-kde
)

print_banner() {
    clear
    echo -e "${BLUE}==========================================${NC}"
    echo -e "${GREEN}      Xandev's CachyOS Rice Installer     ${NC}"
    echo -e "${BLUE}==========================================${NC}"
    echo ""
}

setup_aur_helper() {
    if command -v yay >/dev/null; then
        AUR_HELPER="yay"
        return 0
    elif command -v paru >/dev/null; then
        AUR_HELPER="paru"
        return 0
    fi

    echo -e "${YELLOW}[!] Neither yay nor paru is installed.${NC}"
    read -rp "Do you want to install an AUR helper? [y/N]: " install_aur
    if [[ ! "$install_aur" =~ ^[Yy]$ ]]; then
        AUR_HELPER=""
        return 1
    fi

    echo "Which AUR helper do you want to install?"
    echo "  1) yay"
    echo "  2) paru"
    read -rp "Enter choice [1-2]: " helper_choice

    case "$helper_choice" in
        1)
            sudo pacman -S --needed --noconfirm yay
            AUR_HELPER="yay"
            ;;
        2)
            sudo pacman -S --needed --noconfirm paru
            AUR_HELPER="paru"
            ;;
        *)
            echo -e "${RED}[!] Invalid choice. Skipping AUR helper installation.${NC}"
            AUR_HELPER=""
            return 1
            ;;
    esac
}

install_packages() {
    echo -e "${BLUE}[*] Installing native rice packages...${NC}"
    sudo pacman -Syu --needed --noconfirm "${NATIVE_PKGS[@]}"

    if setup_aur_helper; then
        echo -e "${BLUE}[*] Installing AUR rice packages using $AUR_HELPER...${NC}"
        "$AUR_HELPER" -S --needed --noconfirm "${AUR_PKGS[@]}"
    else
        echo -e "${YELLOW}[!] Skipping AUR packages.${NC}"
    fi
    echo -e "${GREEN}[✓] Package installation complete!${NC}"
}

stow_dotfiles() {
    echo -e "${BLUE}[*] Ensuring GNU Stow is installed...${NC}"
    sudo pacman -S --needed --noconfirm stow

    echo -e "${BLUE}[*] Backing up conflicting default files (if any)...${NC}"
    for file in "$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.gitconfig"; do
        if [ -f "$file" ] && [ ! -L "$file" ]; then
            mv "$file" "$file.bak"
            echo -e "${YELLOW}    Moved existing $file -> $file.bak${NC}"
        fi
    done

    echo -e "${BLUE}[*] Stowing packages from $DOTFILES_DIR...${NC}"
    cd "$DOTFILES_DIR"
    for dir in */; do
        pkg="${dir%/}"
        if [ "$pkg" != "packages" ] && [ "$pkg" != "scripts" ]; then
            stow -v -t "$HOME" "$pkg"
        fi
    done
    echo -e "${GREEN}[✓] All dotfiles stowed successfully!${NC}"
}

setup_nvim() {
    if [ -d "$HOME/.config/nvim" ]; then
        echo -e "${YELLOW}[!] ~/.config/nvim already exists. Skipping clone.${NC}"
    else
        echo -e "${BLUE}[*] Cloning Neovim config...${NC}"
        git clone "$NVIM_REPO" "$HOME/.config/nvim"
        echo -e "${GREEN}[✓] Neovim config cloned!${NC}"
    fi
}

post_setup() {
    echo -e "${BLUE}[*] Enabling user systemd services (mpd, ags)...${NC}"
    systemctl --user daemon-reload
    systemctl --user enable --now mpd.service ags.service || true

    if [ "$SHELL" != "/usr/bin/fish" ] && command -v fish >/dev/null; then
        echo -e "${BLUE}[*] Changing default shell to Fish...${NC}"
        chsh -s /usr/bin/fish
    fi
    echo -e "${GREEN}[✓] Post-setup complete!${NC}"
}

run_all() {
    install_packages
    stow_dotfiles
    setup_nvim
    post_setup
}

while true; do
    print_banner
    echo "Select an action:"
    echo "  1) Full Setup (Run Everything)"
    echo "  2) Install Rice Packages"
    echo "  3) Symlink Dotfiles (GNU Stow)"
    echo "  4) Clone Neovim Config"
    echo "  5) Enable Services & Set Fish Shell"
    echo "  q) Quit"
    echo ""
    read -rp "Enter choice [1-5, q]: " choice
    echo ""

    case "$choice" in
        1) run_all; break ;;
        2) install_packages ;;
        3) stow_dotfiles ;;
        4) setup_nvim ;;
        5) post_setup ;;
        q|Q) echo "Exiting."; exit 0 ;;
        *) echo -e "${RED}Invalid option. Try again.${NC}" ;;
    esac

    echo ""
    read -rp "Press Enter to return to menu..."
done
