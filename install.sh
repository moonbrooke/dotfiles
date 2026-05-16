#!/bin/bash

set -e

echo "Starting dotfiles installation..."

# System Update & Base Requirements
echo "Updating system and installing base-devel, git, and curl..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel git curl

# Install 'yay' for AUR packages
if ! command -v yay &> /dev/null; then
    echo "Installing yay (AUR helper)..."
    git clone https://aur.archlinux.org/yay.git ~/yay
    cd ~/yay
    makepkg -si --noconfirm
    cd ~
    rm -rf ~/yay
else
    echo "yay AUR helper is already installed."
fi

# Install Necessary Packages
echo "Installing necessary core packages..."
sudo pacman -S --needed --noconfirm \
    hyprland swaybg dunst grim slurp jq foot waybar rofi \
    hyprpicker tesseract tesseract-data-jpn tesseract-data-eng \
    ttf-cascadia-mono-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd \
    wl-clipboard cliphist wl-clip-persist hyprpolkitagent \
    xdg-desktop-portal-hyprland thunar thunar-volman gvfs unzip stow nwg-look

# Install Optional but Recommended Packages
echo "Installing optional utilities..."
sudo pacman -S --needed --noconfirm neovim zsh fastfetch yazi fzf bat btop

# Install AUR Packages
echo "Installing additional AUR fonts for CJK support..."
yay -S --needed --noconfirm ttf-ricty-nerd ttf-sarasa-gothic noto-fonts-cjk

# Clone Dotfiles
DOTFILES_DIR="$HOME/dotfiles"
if [ ! -d "$DOTFILES_DIR" ]; then
    echo "Cloning dotfiles repository into ~/"...
    git clone https://github.com/moonbrooke/dotfiles.git "$DOTFILES_DIR"
else
    echo "Dotfiles directory already exists. Pulling latest changes..."
    cd "$DOTFILES_DIR" && git pull && cd ~
fi

# GNU Stow Config
echo "Applying dotfiles with GNU Stow..."
cd "$DOTFILES_DIR"

# Stow the specific folders listed in the README
stow btop dunst fastfetch hypr foot nvim rofi waybar-2 scripts yazi zshrc
mkdir ~/notes

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Change Default Shell to Zsh
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "Changing default shell to zsh..."
    chsh -s /usr/bin/zsh
fi

echo "================================================="
echo "Installation Complete!"
echo "Login via TTY and run 'start-hyprland' to launch the environment."
echo "================================================="
