# dotfiles

**Sept 17, 2026**: Switched to Void Linux.

Dotfiles for my ~~Arch Linux~~ Void Linux setup. Only [Hyprland](https://hypr.land/) setup is used regularly. The other WM configs in this dotfiles are either experimental or abandoned.

### Setup

**IMPORTANT:** DO NOT USE the install scripts as they are intended for personal purpose. And folders in this repo are structured to create symlinks using [GNU Stow](https://www.gnu.org/software/stow/). **Use at your own risk**!

Clone the repo into your home directory then `cd` into it. Run `stow <folder-name>` to create the symlink in your `~/.config` folder.

My current setup consists of the following:

```bash
# The configs you need to stow. You can stow multiple folders at once.
btop dunst fastfetch hypr-void foot nvim rofi waybar-2 scripts yazi zshrc mimeapps
```

- WM/Compositor: [Hyprland](https://hypr.land/)
- Display Manager: None (Login via TTY)
- Colors: switchable — see [Color themes](#color-themes) below
- Terminal: [foot](https://codeberg.org/dnkl/foot)
- Shell: [zsh](https://www.zsh.org/)
- Prompt: [Oh My ZSH](https://ohmyz.sh/)
- Status Bar: [Waybar](https://github.com/Alexays/Waybar)
- Menu: [rofi](https://github.com/davatorium/rofi)
- Screenshot: [grim](https://sr.ht/~emersion/grim/) with [slurp](https://github.com/emersion/slurp)+[jq](https://jqlang.org/)
- File Manager: [Thunar](https://docs.xfce.org/xfce/thunar/start), [yazi](https://github.com/sxyazi/yazi)
- Sysfetch: [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- Editor: [Neovim](https://neovim.io/), [VS Code](https://code.visualstudio.com/)
- Font: [CaskaydiaCove Nerd Font](https://www.nerdfonts.com/font-downloads), [Monocraft Nerd Font](https://github.com/IdreesInc/Monocraft), [Sarasa Gothic](https://github.com/be5invis/sarasa-gothic), [FiraMono Nerd Font](https://www.nerdfonts.com/font-downloads), [JetBrains Mono Nerd Font](https://www.nerdfonts.com/font-downloads), [Ricty Nerd Font](https://rictyfonts.github.io/) (Japanese font), [Noto CJK](https://github.com/notofonts/noto-cjk) (Chinese, Japanese, Korean fonts)

### Color themes

`SUPER + T` opens the rofi picker. Available themes: **Tokyo Night** (default),
**Catppuccin Mocha**, **Catppuccin Latte**, **Rose Pine**, **Rose Pine Dawn**.

```bash
theme              # rofi picker (SUPER + T)
theme list         # all themes with a terminal color preview
theme set cat-mocha
theme current
```

Colors live in `scripts/scripts/themes/palettes/<id>.conf` as `T_*` variables —
that is the only place a color should be edited. Everything else is generated
from it and re-applied live, without logging out:

| Component | How it is themed |
| --- | --- |
| waybar | `style.css` imports `themes/current.css`; the few modules with inline pango colors get rewritten |
| rofi | `config.rasi` / `clipboard.rasi` point at `themes/current.rasi` |
| foot | `foot.ini` includes `themes/current.ini` (`[colors-dark]` or `[colors-light]`) |
| kitty | `kitty.conf` includes `current.conf` (colors + tab bar templates) |
| btop | `btop.conf` uses `color_theme = "current"` |
| dunst | urgency colors rewritten in place in `dunstrc`, then `dunstctl reload` |
| hyprland scripts, `~/scripts`, keyviz | read the palette at runtime via `. "$HOME/scripts/themes/colors"` |
| fastfetch | nothing to do — it uses ANSI indices and follows the terminal |

waybar, dunst and hyprland reload in place. New foot/kitty/btop windows pick the
theme up on launch. GTK/Qt apps keep the Dracula GTK theme in every theme, so
Latte and Dawn only lighten the terminal and bars.

### Screenshot

> Might be a bit outdated, but accurate for the most part.

Screenshot with Waybar, btop, fastfetch, ncmpcpp, Cava, Bitwig Studio, Rofi, and dunst notification.

![hypr-3](https://raw.githubusercontent.com/moonbrooke/dotfiles/refs/heads/main/.github/images/hypr-3.png)
