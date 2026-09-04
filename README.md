# dotfiles

Dotfiles for my Arch Linux setup. Only [Hyprland](https://hypr.land/) setup is used regularly. The other WM configs in this dotfiles are either experimental or abandoned.

### Setup

**IMPORTANT:** Folders in this repo are structured to create symlinks using [GNU Stow](https://www.gnu.org/software/stow/). **Use at your own risk**!

Clone the repo into your home directory then `cd` into it. Run `stow <folder-name>` to create the symlink in your `~/.config` folder.

My current setup consists of the following:

```bash
# The configs you need to stow. You can stow multiple folders at once.
btop dunst fastfetch hypr-lua foot nvim rofi waybar-2 scripts yazi zshrc mimeapps
```

Install dependencies:

```bash
# Necessary for the setup
sudo pacman -S --needed --noconfirm \
    hyprland swaybg dunst grim slurp jq foot waybar rofi awww easyeffects alsa-utils \
    hyprpicker imv udiskie tesseract tesseract-data-jpn tesseract-data-eng \
    ttf-cascadia-mono-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd \
    wl-clipboard cliphist wl-clip-persist hyprpolkitagent rofimoji noto-fonts-emoji \
    xdg-desktop-portal-hyprland thunar thunar-volman gvfs unzip stow nwg-look \
    neovim zsh fastfetch yazi fzf bat btop \
fcitx5 fcitx5-mozc fcitx5-configtool

# Additional fonts for Chinese/Japanese/Korean support
yay -S ttf-ricty-nerd ttf-sarasa-gothic noto-fonts-cjk --needed --noconfirm
```

- WM/Compositor: [Hyprland](https://hypr.land/)
- Display Manager: None (Login via TTY then run `start-hyprland`)
- Colors: [Tokyo Night](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- Terminal: [foot](https://codeberg.org/dnkl/foot)
- Shell: [zsh](https://www.zsh.org/)
- Prompt: [Oh My ZSH](https://ohmyz.sh/)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Menu: [rofi](https://github.com/davatorium/rofi)
- Screenshot: [grim](https://sr.ht/~emersion/grim/) with [slurp](https://github.com/emersion/slurp)+[jq](https://jqlang.org/)
- File Manager: [Thunar](https://docs.xfce.org/xfce/thunar/start), [yazi](https://github.com/sxyazi/yazi)
- Sysfetch: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- Editor: [Neovim](https://neovim.io/), [VS Code](https://code.visualstudio.com/)
- Font: [CaskaydiaCove Nerd Font](https://www.nerdfonts.com/font-downloads), [FiraMono Nerd Font](https://www.nerdfonts.com/font-downloads), [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads), [Ricty Nerd Font](https://rictyfonts.github.io/) (Japanese font), [Noto CJK](https://github.com/notofonts/noto-cjk) (Chinese, Japanese, Korean fonts)

### Screenshot

Screenshot with Waybar, btop, fastfetch, ncmpcpp, Cava, Bitwig Studio, Rofi, and dunst notification.

![hypr-3](https://raw.githubusercontent.com/moonbrooke/dotfiles/refs/heads/main/.github/images/hypr-3.png)
