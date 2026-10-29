# dotfiles

This is a personal Linux dotfiles. The configurations are frequently tweaked. Only [Hyprland](https://hypr.land/) setup is being used regularly. The other WM/Compositor configurations are either experimental or abandoned.

### Setup

**IMPORTANT:** DO NOT USE the install scripts as they are intended for personal purpose. And folders in this repo are structured to create symlinks using [GNU Stow](https://www.gnu.org/software/stow/). **Use at your own risk**!

Clone the repo into your home directory then `cd` into it. Run `stow <folder-name>` to create the symlink in your `~/.config` folder.

My current setup consists of the following:

```bash
# The configs you need to stow. You can stow multiple folders at once.
btop dunst fastfetch hypr foot kitty nvim rofi waybar scripts yazi zshrc app-flags mimeapps television
```

- WM/Compositor: [Hyprland](https://hypr.land/)
- Display Manager: None (Login via TTY)
- Colors: [Tokyo Night](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- Terminal: [kitty](https://github.com/kovidgoyal/kitty), [foot](https://codeberg.org/dnkl/foot)
- Shell: [zsh](https://www.zsh.org/)
- Prompt: [Oh My ZSH](https://ohmyz.sh/)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Menu/Launcher: [rofi](https://github.com/davatorium/rofi)
- Screenshot: [grim](https://sr.ht/~emersion/grim/) with [slurp](https://github.com/emersion/slurp) and [jq](https://jqlang.org/)
- File Manager: [Thunar](https://docs.xfce.org/xfce/thunar/start), [Strata](https://github.com/lgse/strata), [yazi](https://github.com/sxyazi/yazi)
- Sysfetch: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- Editor: [Neovim](https://neovim.io/), [VS Code](https://code.visualstudio.com/)
- Font:
    - [IosevkaTerm Nerd Font](https://www.nerdfonts.com/font-downloads) (Main)
    - [Sarasa Gothic](https://github.com/be5invis/sarasa-gothic) (Japanese font support)
    - [Noto CJK](https://github.com/notofonts/noto-cjk) (Chinese, Japanese, Korean fonts support)
    - [CaskaydiaCove Nerd Font](https://www.nerdfonts.com/font-downloads)
    - [FiraMono Nerd Font](https://www.nerdfonts.com/font-downloads)
    - [Ricty Nerd Font](https://rictyfonts.github.io/) (Japanese font support)

### Screenshot

![Hyprland Screenshot](./.github/images/hypr-5.png)
