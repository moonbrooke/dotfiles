# Theme Switcher Plan — Tokyo Night ↔ Tokyo Dawn

## Goal

Add a rofi-driven color theme switcher for the Void Linux + Hyprland setup.

- Themes: **Tokyo Night** (default) and **Tokyo Dawn**.
- Menu: rofi dmenu picker.
- Applying a theme updates Hyprland, Waybar, Dunst, Kitty, Foot, Btop, and Rofi.
- Changes apply **live** — no logout, no Hyprland restart, no Waybar restart required.
- Palette source of truth: the two helper scripts in `scripts/scripts/`:
  - `tokyonight`
  - `tokyodawn`

## Current state (relevant facts)

- Configs are GNU Stow symlinks from the repo into `~/.config/...`.
- `scripts/scripts/` is stowed as `~/scripts/`.
- Hyprland is **Lua-configured** (`hyprland.lua`, `_appearance.lua`, etc.) and supports `hyprctl eval "hl.config({...})"`.
- Waybar has `reload_style_on_change: true` and uses CSS `@define-color` names.
- Kitty currently hardcodes `include tokyo-night.conf` and has tab-title templates with hardcoded hex values.
- Foot currently has only `[colors-dark]`; Foot 1.28 supports `[colors-dark]` / `[colors-light]` plus `initial-color-theme` and `SIGUSR1`/`SIGUSR2`.
- Dunst 1.13.2 has no `include` support, so its colors must be rewritten in place.
- Rofi is 2.0.0; it reads its theme on every launch.
- Prior art: `origin/theme-changer` (commit `412a715`) contains a working multi-theme switcher (`scripts/scripts/theme`, `themes/lib.sh`, palettes, templates). Adapt that instead of starting from scratch.

## Design

### One palette, generated outputs

```
scripts/scripts/themes/
├── colors                      # source this to get $T_* in other scripts
├── lib.sh                      # palette loading + render/apply/reload helpers
├── palettes/
│   ├── tokyonight.conf         # Tokyo Night palette
│   └── tokyodawn.conf          # Tokyo Dawn palette
└── templates/
    ├── btop.theme.in
    ├── kitty.conf.in
    ├── rofi.rasi.in
    ├── theme-colors.lua.in
    └── waybar.css.in
```

`scripts/scripts/theme` is the CLI/menu entry point.

State:

```
~/.cache/theme_state            # "tokyonight" or "tokyodawn"
~/.cache/theme_colors.lua       # generated Lua table for Hyprland
```

Generated “current” pointers (symlinks) inside the stowed config dirs:

```
~/.config/rofi/themes/current.rasi
~/.config/kitty/current.conf
~/.config/waybar/themes/current.css
~/.config/btop/themes/current.theme
```

Per-theme rendered files (`tokyonight.*`, `tokyodawn.*`) are tracked in git. The `current.*` pointers are gitignored.

### Palette variables

Each palette exports:

```
T_NAME  T_MODE
T_BG  T_BG_ALT  T_SURFACE
T_FG  T_FG_DIM  T_FG_MUTED
T_ACCENT
T_BORDER_ACTIVE_1  T_BORDER_ACTIVE_2  T_BORDER_INACTIVE
T_RED  T_GREEN  T_YELLOW  T_BLUE  T_PURPLE  T_AQUA  T_ORANGE
T_CURSOR
```

`lib.sh` also exports bare-hex variants (`T_BG_N`, etc., without `#`) for Kitty, Foot, and Hyprland.

#### Tokyo Night

| Variable | Hex | Use |
| --- | --- | --- |
| `T_BG` | `#1a1b26` | main background |
| `T_BG_ALT` | `#24283b` | raised background / selection |
| `T_SURFACE` | `#414868` | borders, selected rows, frame |
| `T_FG` | `#c0caf5` | primary text |
| `T_FG_DIM` | `#a9b1d6` | secondary text |
| `T_FG_MUTED` | `#565f89` | muted text |
| `T_ACCENT` | `#414868` | rofi prompt/accent |
| `T_BORDER_ACTIVE_1` | `#9aa5ce` | Hyprland active border |
| `T_BORDER_ACTIVE_2` | `#565f89` | Hyprland active border |
| `T_BORDER_INACTIVE` | `#24283b` | Hyprland inactive border |
| `T_RED` | `#f7768e` | |
| `T_GREEN` | `#9ece6a` | |
| `T_YELLOW` | `#e0af68` | |
| `T_BLUE` | `#7aa2f7` | |
| `T_PURPLE` | `#bb9af7` | |
| `T_AQUA` | `#7dcfff` | |
| `T_ORANGE` | `#ff9e64` | |
| `T_CURSOR` | `#bb9af7` | |

#### Tokyo Dawn

The `tokyodawn` helper is the Rosé Pine Dawn palette. Mapping follows the existing `rose-pine-dawn` palette from the old branch.

| Variable | Hex | Use |
| --- | --- | --- |
| `T_BG` | `#faf4ed` | base |
| `T_BG_ALT` | `#f2e9e1` | overlay |
| `T_SURFACE` | `#dfdad9` | highlight / frame |
| `T_FG` | `#464261` | text |
| `T_FG_DIM` | `#797593` | subtle |
| `T_FG_MUTED` | `#9893a5` | muted |
| `T_ACCENT` | `#907aa9` | iris accent |
| `T_BORDER_ACTIVE_1` | `#907aa9` | Hyprland active border |
| `T_BORDER_ACTIVE_2` | `#9893a5` | Hyprland active border |
| `T_BORDER_INACTIVE` | `#dfdad9` | Hyprland inactive border |
| `T_RED` | `#b4637a` | love |
| `T_GREEN` | `#56949f` | foam |
| `T_YELLOW` | `#ea9d34` | gold |
| `T_BLUE` | `#286983` | pine |
| `T_PURPLE` | `#907aa9` | iris |
| `T_AQUA` | `#56949f` | foam |
| `T_ORANGE` | `#d7827e` | rose |
| `T_CURSOR` | `#907aa9` | iris |

Unused helper colors (`#fffaf3`, `#f4ede8`, `#cecacd`) are available if a later component needs a softer surface/highlight.

## CLI and rofi menu

`scripts/scripts/theme` (stowed as `~/scripts/theme`):

```
theme                  # open rofi picker
theme menu             # same
theme list             # terminal preview of both themes
theme set <name>       # apply + notify
theme apply [name]     # apply silently (for autostart); defaults to current
theme current          # print active id
theme names            # print theme ids
theme --help
```

Name aliases:

- `tokyonight`, `tokyo-night`, `tokyonight`, `night`, `Tokyo Night`
- `tokyodawn`, `tokyo-dawn`, `tokyodawn`, `dawn`, `Tokyo Dawn`

Rofi invocation:

```bash
rofi -dmenu -markup-rows -format 'p' -i -no-custom \
  -p "Theme" -line-padding 4 -hide-scrollbar \
  -theme "$HOME/.config/rofi/config.rasi" \
  -theme-str "window {width: 40%; border: 3px; border-color: $T_BG_ALT;}"
```

Each row shows the display name, an `(Active)` marker in `$T_FG_MUTED`, and five color swatches (`$T_BG`, `$T_RED`, `$T_YELLOW`, `$T_GREEN`, `$T_BLUE`).

`theme` reads `config.rasi`, which already points at `themes/current.rasi`, so the picker uses the active theme.

## Per-application integration

### Rofi

**Files**

- Modify `rofi/.config/rofi/config.rasi`
  - `@theme "./themes/current.rasi"`
- Modify `rofi/.config/rofi/clipboard.rasi`
  - `@theme "./themes/current.rasi"`
- Leave `power.rasi` alone (not used by current scripts; `rofi-power` uses `config.rasi`).
- Add `rofi/.config/rofi/themes/tokyonight.rasi` (generated, tracked)
- Add `rofi/.config/rofi/themes/tokyodawn.rasi` (generated, tracked)
- Add `rofi/.config/rofi/themes/current.rasi` symlink (generated, gitignored)

**Template**

Adapt the existing `tokyonight.rasi` look, parameterized:

```
bg0 = T_BG
bg1 = T_BG_ALT
fg0 = T_FG
accent-color = T_ACCENT
urgent-color = T_YELLOW
window { border: 3px; border-color: @bg1; }
```

Keep the current font (`IosevkaTerm Nerd Font Medium 14`), window width, and element spacing.

**Live behavior**

Rofi is not a daemon; the new theme is used on the next rofi launch. No reload needed.

### Kitty

**Files**

- Modify `kitty/.config/kitty/kitty.conf`
  - Change `include tokyo-night.conf` → `include current.conf`
  - Remove the two hardcoded `tab_title_template` / `active_tab_title_template` lines (move them into the generated theme).
- Add `kitty/.config/kitty/tokyonight.conf` (generated, tracked)
- Add `kitty/.config/kitty/tokyodawn.conf` (generated, tracked)
- Add `kitty/.config/kitty/current.conf` symlink (generated, gitignored)
- Retire `kitty/.config/kitty/tokyo-night.conf`, `current-theme.conf`, and the unused Catppuccin/Rosé Pine theme files (keep in git history).

**Template**

Generate the full color block:

- foreground / background
- selection foreground/background
- cursor + cursor text
- URL color
- active/inactive/bell border colors
- active/inactive tab colors
- `color0`–`color15`
- `tab_title_template` and `active_tab_title_template`

Use palette-derived hex names so both themes work:

```
tab_title_template        "{fmt.fg._<FG_MUTED_N>}{fmt.bg._<BG_N>}..."
active_tab_title_template "{fmt.fg._<BLUE_N>}{fmt.bg._<BG_N>}..."
```

This preserves the current Night look (`#565f89` inactive, `#7aa2f7` active) and gives Dawn readable light tab titles.

**Live behavior**

```bash
pkill -USR1 -x kitty || true
```

Kitty reloads `kitty.conf` (including `current.conf`) for all windows. `auto_reload_config` may already handle the file change; the signal makes it deterministic.

### Foot

**Files**

- Modify `foot/.config/foot/foot.ini`
  - Add `initial-color-theme = dark` (or `light`) in the implicit `[main]` section.
  - Keep `[colors-dark]` and add `[colors-light]` with the full palette mapping.
- No generated include file: both palettes live statically in `foot.ini`. This fixes a weakness in the old branch, where only one section was generated and new Foot windows could fall back to built-in colors.

**Mapping** (same as the old template):

```
foreground = T_FG
background = T_BG
regular0 = T_BG_ALT
regular1 = T_RED
regular2 = T_GREEN
regular3 = T_YELLOW
regular4 = T_BLUE
regular5 = T_PURPLE
regular6 = T_AQUA
regular7 = T_FG_DIM
bright0 = T_SURFACE
bright1 = T_RED
bright2 = T_GREEN
bright3 = T_YELLOW
bright4 = T_BLUE
bright5 = T_PURPLE
bright6 = T_AQUA
bright7 = T_FG
dim0 = T_ORANGE
dim1 = T_RED
```

**Live behavior**

The switcher rewrites the `initial-color-theme` line with `sed`, then:

```bash
# Tokyo Night
pkill -USR1 -x foot || true
pkill -USR1 -x footclient || true

# Tokyo Dawn
pkill -USR2 -x foot || true
pkill -USR2 -x footclient || true
```

`SIGUSR1` selects `[colors-dark]`; `SIGUSR2` selects `[colors-light]`. New Foot windows use `initial-color-theme`.

Validate with:

```bash
foot -C -c ~/.config/foot/foot.ini
```

### Waybar

**Files**

- Modify `waybar/.config/waybar/style.css`
  - Replace the hardcoded `@define-color` block with:
    ```css
    @import url("themes/current.css");
    ```
    This must be the first rule in the file.
- Add `waybar/.config/waybar/themes/tokyonight.css` (generated, tracked)
- Add `waybar/.config/waybar/themes/tokyodawn.css` (generated, tracked)
- Replace the current text file `waybar/.config/waybar/themes/current.css` with a symlink (generated, gitignored).

**Palette CSS**

```css
@define-color black  <T_BG>;
@define-color red    <T_RED>;
@define-color green  <T_GREEN>;
@define-color yellow <T_YELLOW>;
@define-color blue   <T_BLUE>;
@define-color purple <T_PURPLE>;
@define-color aqua   <T_AQUA>;
@define-color gray   <T_FG_MUTED>;
@define-color white  <T_FG>;
@define-color muted  <T_BG_ALT>;
```

**Inline module colors**

Waybar module `format` strings cannot resolve CSS variables, so rewrite the first hex in these files:

| File | Replacement |
| --- | --- |
| `modules/hyprland/window.jsonc` | `T_FG` |
| `modules/custom/layout.jsonc` | `T_GREEN` |
| `modules/custom/layout-double.jsonc` | `T_GREEN` |
| `modules/datetime.jsonc` `months` | `T_AQUA` |
| `modules/datetime.jsonc` `days` | `T_FG` |
| `modules/datetime.jsonc` `weeks` | `T_GREEN` |
| `modules/datetime.jsonc` `weekdays` | `T_YELLOW` |
| `modules/datetime.jsonc` `today` | `T_RED` |

Use the old `theme_waybar_modules` approach (awk replace by line/key, not by current value) so it is idempotent.

**Live behavior**

```bash
pkill -USR2 -x waybar || true
```

Waybar’s default `on-sigusr2` is `reload`, which re-reads the config and style. `reload_style_on_change: true` also picks up the new imported CSS. If a future Waybar version does not apply the JSON module changes, fall back to the existing restart pattern (`pkill waybar; sleep 0.4; ~/scripts/waybar-launch &`). The plan is to use `SIGUSR2` first because it preserves bar state.

### Btop

**Files**

- Modify `btop/.config/btop/btop.conf`
  - `color_theme = "current"`
- Add `btop/.config/btop/themes/tokyonight.theme` (generated, tracked)
- Add `btop/.config/btop/themes/tokyodawn.theme` (generated, tracked)
- Add `btop/.config/btop/themes/current.theme` symlink (generated, gitignored)
- Retire the old `tokyo-night.theme` (superseded; keep in git history).

**Template**

Use the old `btop.theme.in` mapping:

```
main_bg = T_BG
main_fg / title = T_FG
hi_fg / proc_misc = T_AQUA
selected_bg = T_SURFACE
selected_fg = T_FG
inactive_fg = T_FG_MUTED
box outlines / div_line = T_FG_MUTED
graphs = T_GREEN → T_YELLOW → T_RED
```

**Live behavior**

```bash
pkill -USR2 -x btop || true
```

Btop hot-reloads its config and active theme on `SIGUSR2`. Known btop issue: signaling within the first few seconds of startup can crash; normal theme switching is unaffected.

### Dunst

Dunst has no include/import, so rewrite only the color keys in place.

**Files**

- Modify `dunst/.config/dunst/dunstrc` (script-managed colors):
  - `[global] frame_color` → `T_SURFACE`
  - `[urgency_low]` / `[urgency_normal]`:
    - `background` → `T_BG`
    - `foreground` → `T_FG_DIM`
    - `frame_color` → `T_SURFACE`
  - `[urgency_critical]`:
    - `background` → `T_BG`
    - `foreground` → `T_FG`
    - `frame_color` → `T_SURFACE`

Use the old awk-based `theme_dunst` function: match section + key, preserve comments/indentation, write to a temp file and `mv`.

**Live behavior**

```bash
if command -v dunstctl >/dev/null && pgrep -x dunst >/dev/null; then
  dunstctl reload || true
fi
```

### Hyprland

**Files**

- Add `hypr/.config/hypr/_theme_colors.lua`? No — generate `~/.cache/theme_colors.lua` instead, following the existing `~/.cache/hypr_*` state pattern.
- Modify `hypr/.config/hypr/_appearance.lua`
  - Load `~/.cache/theme_colors.lua` with `pcall(dofile, path)`.
  - Fall back to the current Tokyo Night border colors if the cache file is missing.
  - Use the table for:
    - `general.col.active_border.colors`
    - `general.col.inactive_border`
    - `decoration.shadow.color` / `color_inactive` (shadow is disabled, but keep it consistent)
- Modify `hypr/.config/hypr/_layout.lua`
  - Use `theme.green` for the layout-switch notification accent instead of hardcoded `#9ece6a`.
  - The generated table stores bare hex, so the markup needs a `#` prefix: `<span color=\"#" .. theme.green .. "\">`.
- Modify `hypr/.config/hypr/_keybind.lua`
  - Add `local theme = "~/scripts/theme"`
  - Add `hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(theme))`
  - `SUPER + T` is currently free.
- Modify `hypr/.config/hypr/_autostart.lua`
  - Add `"~/scripts/theme apply"` as the first command in both `arch_cmds` and `void_cmds`.
  - This silently regenerates files and re-applies borders before Dunst/Waybar start.

**Generated Lua table** (`~/.cache/theme_colors.lua`)

```lua
return {
    name = "Tokyo Night",
    mode = "dark",
    bg = "1a1b26",
    bg_alt = "24283b",
    surface = "414868",
    fg = "c0caf5",
    fg_dim = "a9b1d6",
    fg_muted = "565f89",
    accent = "414868",
    border_active_1 = "9aa5ce",
    border_active_2 = "565f89",
    border_inactive = "24283b",
    red = "f7768e",
    green = "9ece6a",
    yellow = "e0af68",
    blue = "7aa2f7",
    purple = "bb9af7",
    aqua = "7dcfff",
    orange = "ff9e64",
}
```

All values are bare hex (no `#`) for direct use in `rgb(...)`.

**`_appearance.lua` sketch**

```lua
local function load_theme()
    local ok, colors = pcall(dofile, utils.cache_path("theme_colors.lua"))
    if ok and type(colors) == "table" then
        return colors
    end
    return {
        border_active_1 = "9aa5ce",
        border_active_2 = "565f89",
        border_inactive = "24283b",
        fg = "c0caf5",
    }
end

local theme = load_theme()

hl.config({
    general = {
        col = {
            active_border = {
                colors = {
                    "rgb(" .. theme.border_active_1 .. ")",
                    "rgb(" .. theme.border_active_2 .. ")",
                },
                angle = 45,
            },
            inactive_border = "rgb(" .. theme.border_inactive .. ")",
        },
    },
    decoration = {
        shadow = {
            color = "rgb(" .. theme.fg .. ")",
            color_inactive = "rgba(" .. theme.fg .. "00)",
        },
    },
})
```

**Live behavior**

Apply immediately with `hyprctl eval`, then reload the config for any other theme-aware Lua:

```bash
hyprctl eval "hl.config({
  general = {
    col = {
      active_border = {
        colors = {'rgb(<BORDER_ACTIVE_1_N>)', 'rgb(<BORDER_ACTIVE_2_N>)'},
        angle = 45
      },
      inactive_border = 'rgb(<BORDER_INACTIVE_N>)'
    }
  },
  decoration = {
    shadow = {
      color = 'rgb(<FG_N>)',
      color_inactive = 'rgba(<FG_N>00)'
    }
  }
})" || true

hyprctl reload || true
```

No Hyprland restart, no logout.

### Other scripts (optional consistency pass)

Many existing scripts hardcode Tokyo Night hex values in `notify-send` markup and rofi `-theme-str` (e.g. `toggle-gaps`, `brightness`, `waybar-menu`, `rofi-power`, `rofi-cliphist`, `keybinds`, `notif-history`, `capslock`, `rofi-wallpaper`, `rofi-monitor`, `set-gaps`, `rofi-jisho`, `keyviz`).

To keep Dawn readable (light notification backgrounds with dark text), source the palette and use `$T_*`:

```bash
. "$HOME/scripts/themes/colors"
```

Replacements:

- success / enabled → `$T_GREEN`
- error / disabled / destructive → `$T_RED`
- muted / active marker → `$T_FG_MUTED`
- borders / selected chrome → `$T_BG_ALT` or `$T_SURFACE`
- primary text → `$T_FG`
- accents → `$T_BLUE` / `$T_AQUA` / `$T_YELLOW`

This is mechanical but touches many files. It is recommended, but the core switcher works without it. The old branch also had `themes/check`, a small Python linter that catches `$T_` inside single quotes and scripts that use `$T_*` without loading the palette; port it if doing this pass.

For `keyviz` (Python), either leave its HUD dark or update `load_theme_colors()` to read `~/.config/waybar/themes/current.css` and parse the `@define-color` values. Add `bg`/`fg`/`accent`/`border`/`capsule_bg` aliases to `waybar.css.in` if doing this.

## Live reload matrix

| Component | Mechanism | Command | Notes |
| --- | --- | --- | --- |
| Hyprland | `hyprctl eval` + `hyprctl reload` | see above | borders/shadows update immediately |
| Waybar | `SIGUSR2` | `pkill -USR2 -x waybar` | reloads config + style; fallback restart if needed |
| Dunst | `dunstctl reload` | `dunstctl reload` | no restart |
| Kitty | `SIGUSR1` | `pkill -USR1 -x kitty` | all windows |
| Foot | `SIGUSR1` / `SIGUSR2` | `pkill -USR1/-USR2 -x foot` | dark/light; also footclient |
| Btop | `SIGUSR2` | `pkill -USR2 -x btop` | hot reload config + theme |
| Rofi | none | — | next launch reads `current.rasi` |
| GTK/Qt apps | none | — | out of scope; remain Dracula/dark |

All signal commands must be guarded:

```bash
pgrep -x waybar >/dev/null 2>&1 && pkill -USR2 -x waybar || true
```

## Persistence and `.gitignore`

Add to `.gitignore`:

```gitignore
# Color theme switcher: only the current.* pointers move; rendered
# per-theme files are tracked so switches stay diff-free.
waybar/.config/waybar/themes/current.css
rofi/.config/rofi/themes/current.rasi
kitty/.config/kitty/current.conf
btop/.config/btop/themes/current.theme
```

`~/.cache/theme_state` and `~/.cache/theme_colors.lua` are outside the repo and need no ignore.

On a fresh clone, the `current.*` symlinks are absent. `~/scripts/theme apply` in autostart regenerates them before Kitty/Rofi/Waybar/Btop launch. Hyprland’s `_appearance.lua` has a Night fallback if `~/.cache/theme_colors.lua` is missing.

## Implementation phases

1. **Palette + shared library**
   - Add `themes/palettes/tokyonight.conf`, `tokyodawn.conf`.
   - Port `themes/lib.sh` from `origin/theme-changer`, reduce `THEME_IDS` to the two themes, add the new border/accent variables.
   - Add `themes/colors`.
   - Implement palette loading, validation, aliases, state read/write, render helpers, symlink helper.

2. **Templates + generation**
   - Port/adapt `rofi.rasi.in`, `kitty.conf.in`, `btop.theme.in`, `waybar.css.in`, `theme-colors.lua.in`.
   - Generate both per-theme variants and the `current.*` symlinks.
   - Verify rendered files by inspection.

3. **Config wiring**
   - Rofi: point `config.rasi` and `clipboard.rasi` at `themes/current.rasi`.
   - Kitty: include `current.conf`; remove hardcoded tab templates.
   - Foot: add both color sections and `initial-color-theme`.
   - Waybar: replace `@define-color` block with `@import`.
   - Btop: `color_theme = "current"`.
   - Dunst: seed Night colors; script will rewrite them.

4. **Hyprland**
   - Generate `~/.cache/theme_colors.lua`.
   - Update `_appearance.lua`, `_layout.lua`.
   - Add `SUPER + T` keybind.
   - Add `~/scripts/theme apply` to both autostart lists.

5. **Reload logic**
   - Implement `theme_reload` with the matrix above.
   - Guard every optional process/tool.
   - Test each signal individually.

6. **Rofi menu + CLI**
   - Implement `theme`, `theme menu`, `theme list`, `theme set`, `theme apply`, `theme current`, `theme names`.
   - Add swatches and `(Active)` marker.
   - Test via `SUPER + T` and from a terminal.

7. **Cleanup**
   - Remove/retire obsolete static theme files.
   - Update `.gitignore`.
   - Document in `README.md` (Color themes section).

8. **Optional consistency pass**
   - Replace hardcoded notification/menu hex values with `$T_*`.
   - Update `keyviz` palette loading.
   - Port `themes/check` linter.

9. **Verification** (below).

## Verification checklist

1. Syntax:
   ```bash
   bash -n scripts/scripts/theme
   bash -n scripts/scripts/themes/lib.sh
   foot -C -c ~/.config/foot/foot.ini
   ```
   Run `shellcheck` if installed.

2. CLI:
   ```bash
   ~/scripts/theme list
   ~/scripts/theme current
   ~/scripts/theme names
   ```

3. Switch to Dawn:
   ```bash
   ~/scripts/theme set tokyodawn
   ```
   Check:
   - `cat ~/.cache/theme_state` → `tokyodawn`
   - `readlink ~/.config/rofi/themes/current.rasi` → `tokyodawn.rasi`
   - `readlink ~/.config/kitty/current.conf` → `tokyodawn.conf`
   - `readlink ~/.config/waybar/themes/current.css` → `tokyodawn.css`
   - `readlink ~/.config/btop/themes/current.theme` → `tokyodawn.theme`
   - `grep '^initial-color-theme' ~/.config/foot/foot.ini` → `light`
   - `hyprctl getoption general:col.active_border` → Dawn border colors
   - `grep -A3 '\[urgency_normal\]' ~/.config/dunst/dunstrc` → light colors
   - `grep -n '"months"' ~/.config/waybar/modules/datetime.jsonc` → Dawn aqua

4. Live behavior (with apps open):
   - Hyprland borders change immediately.
   - Waybar colors change without the bar disappearing.
   - Dunst notification uses the new colors (send a test notification).
   - Existing Kitty windows change.
   - Existing Foot windows change.
   - Running Btop changes.
   - New Kitty/Foot/Btop windows start in Dawn.
   - Rofi opens in Dawn.

5. Switch back:
   ```bash
   ~/scripts/theme set tokyonight
   ```
   Verify all of the above return to Night.

6. Menu:
   - Press `SUPER + T`; pick Dawn; confirm notification and live changes.
   - Press `SUPER + T` again; pick Night.

7. Robustness:
   - Run `~/scripts/theme apply` twice; no errors, idempotent.
   - Switch with Kitty/Foot/Btop/Waybar/Dunst closed; no errors.
   - Temporarily remove `~/.config/waybar/themes/current.css`; run `theme apply`; file is recreated.
   - Temporarily remove `~/.cache/theme_colors.lua`; Hyprland fallback works; `theme apply` recreates it.

## Out of scope

- GTK/Qt application themes (remain Dracula/dark; Dawn only lightens terminal/bars/notifications).
- `hyprlock` theming (not installed on this system; can be added later with a generated include).
- Other terminals/compositors in the dotfiles (Alacritty, Ghostty, bspwm, etc.).
- Neovim/Yazi/Cava/fastfetch themes (fastfetch follows ANSI; Neovim/Yazi have their own theme systems).
- Wallpaper changes.
- Automatic day/night scheduling (could later be a timer calling `theme set tokyodawn` / `theme set tokyonight`).

## Assumptions / decisions

- Only two themes, per the request.
- Tokyo Dawn uses the Rosé Pine Dawn palette from `scripts/scripts/tokyodawn`; green/aqua map to foam `#56949f`, blue to pine `#286983`.
- Tokyo Night keeps its current border colors (`#9aa5ce` / `#565f89`) so switching back restores the exact current look.
- `SUPER + T` is free and will open the picker.
- Generated per-theme files are tracked; `current.*` pointers are gitignored.
- Dunst and Waybar module JSON colors are rewritten in place because those formats cannot import external color files cleanly; expect color-only git diffs after switching.
- The old `origin/theme-changer` implementation is the starting point, adapted to the current Lua Hyprland config and current Waybar module layout.
