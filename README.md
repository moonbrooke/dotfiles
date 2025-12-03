# dotfiles

dotfiles for my Arch Linux setup. Only [Hyprland](https://hyprland.org/) setup is being used regularly. Other WM configs in this dotfiles are either experimental or abandoned.

**IMPORTANT:** The folders are structured to create symlinks using [GNU Stow](https://www.gnu.org/software/stow/). And **use at your own risk**!

### Setup

My current setup consists of the following configs:

```bash
# Use GNU Stow to create the symlinks
stow btop dunst-3 fastfetch hypr-3 kitty nvim-vanilla rofi-3 waybar-2 yazi-2 zshrc-2
```

Install dependencies:

```bash
# I might forget some packages
sudo pacman -S hyprland hyprpaper dunst grim slurp jq ly neovim kitty zsh waybar rofi \
fastfetch neovim ttf-cascadia-mono-nerd otf-firamono-nerd ttf-jetbrains-mono-nerd \
wl-clipboard cliphist hyprpolkitagent xdg-desktop-portal-hyprland xdg-dekstop-portal \
yazi fzf bat btop unzip git stow mpd ncmpcpp --needed
```

- WM/Compositor: [Hyprland](https://hyprland.org/)
- Display Manager: [Ly](https://codeberg.org/fairyglade/ly)
- Colors: [Tokyo Night](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- Terminal: [kitty](https://sw.kovidgoyal.net/kitty/)
- Shell: [zsh](https://www.zsh.org/)
- Prompt: [Oh My ZSH](https://ohmyz.sh/)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Menu: [rofi](https://github.com/davatorium/rofi)
- Screenshot: [grim](https://sr.ht/~emersion/grim/) with [slurp](https://github.com/emersion/slurp)+[jq](https://jqlang.org/)
- Sysfetch: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- Editor: [Neovim](https://neovim.io/), [VS Code](https://code.visualstudio.com/)
- Font: [CaskaydiaCove Nerd Font](https://www.nerdfonts.com/font-downloads), [FiraMono Nerd Font](https://www.nerdfonts.com/font-downloads), [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads), [Ricty Nerd Font](https://rictyfonts.github.io/) (for Japanese characters support)

### Screenshot

Screenshot with Waybar, btop, fastfetch, ncmpcpp, Cava, Bitwig Studio, Rofi, and dunst notification.

![hypr-3](https://raw.githubusercontent.com/moonbrooke/dotfiles/refs/heads/main/.github/images/hypr-3.png)
