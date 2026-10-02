#!/usr/bin/env bash
#
# ~/scripts/themes/lib.sh -- shared helpers for the color theme switcher.
#
# Colors live in palettes/<id>.conf as T_* variables. Everything the desktop
# renders (rofi themes, foot/kitty/btop color files, the waybar @define-color
# block, dunst urgency colors) is generated from those, so a palette is the only
# thing that ever needs editing by hand.
#
# Sourced by ~/scripts/theme and by any script that wants a live color, e.g.
#     . "$HOME/scripts/themes/lib.sh"
#     theme_load "$(theme_current)"
#     notify-send 'Settings' "Done <span color=\"$T_GREEN\">OK</span>"

THEMES_DIR="$HOME/scripts/themes"
PALETTE_DIR="$THEMES_DIR/palettes"
TEMPLATE_DIR="$THEMES_DIR/templates"
STATE_FILE="$HOME/.cache/theme-state"
DEFAULT_THEME="tokyonight"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Ordered theme list for menus and `theme list`.
THEME_IDS=(
    tokyonight
    cat-mocha
    cat-latte
    rose-pine
    rose-pine-dawn
)

log() { printf '%s\n' "$*" >&2; }
die() {
    printf '%s\n' "$*" >&2
    exit 1
}

theme_valid() {
    local id
    for id in "${THEME_IDS[@]}"; do
        [ "$id" = "$1" ] && return 0
    done
    return 1
}

# Resolve a user supplied name to a theme id. Accepts the id, the display name,
# and loose substrings, all case/dash/space insensitive: "Latte", "cat latte"
# and "cat-latte" all resolve to cat-latte.
theme_resolve() {
    [ -n "$1" ] || return 1
    local want name id
    want=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr '_ ' '--')

    for id in "${THEME_IDS[@]}"; do
        [ "$id" = "$want" ] && {
            printf '%s' "$id"
            return 0
        }
    done

    for id in "${THEME_IDS[@]}"; do
        theme_load_quiet "$id" || continue
        name=$(printf '%s' "$T_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
        [ "$name" = "$want" ] && {
            printf '%s' "$id"
            return 0
        }
    done

    for id in "${THEME_IDS[@]}"; do
        case "$id" in
            *"$want"*)
                printf '%s' "$id"
                return 0
                ;;
        esac
    done

    return 1
}

theme_load_quiet() {
    [ -f "$PALETTE_DIR/$1.conf" ] || return 1
    # shellcheck disable=SC1090
    . "$PALETTE_DIR/$1.conf"
}

# Load a palette and export everything the renderer needs.
theme_load() {
    local id=$1
    [ -f "$PALETTE_DIR/$id.conf" ] || die "unknown theme: $id"
    unset T_NAME T_MODE T_BG T_BG_ALT T_SURFACE T_FG T_FG_DIM T_FG_MUTED
    unset T_RED T_GREEN T_YELLOW T_BLUE T_PURPLE T_AQUA T_ORANGE T_CURSOR
    # shellcheck disable=SC1090
    . "$PALETTE_DIR/$id.conf"
    export T_ID="$id"

    if [ "$T_MODE" = "light" ]; then
        export T_SECTION="light"
    else
        export T_SECTION="dark"
    fi

    # kitty wants bare hex (no leading #)
    local suffix name val
    for suffix in BG BG_ALT SURFACE FG FG_DIM FG_MUTED RED GREEN YELLOW BLUE \
        PURPLE AQUA ORANGE CURSOR; do
        name="T_${suffix}"
        val=${!name}
        printf -v "T_${suffix}_N" '%s' "${val#\#}"
        export "T_${suffix}_N"
    done

    export T_NAME T_MODE T_BG T_BG_ALT T_SURFACE T_FG T_FG_DIM T_FG_MUTED
    export T_RED T_GREEN T_YELLOW T_BLUE T_PURPLE T_AQUA T_ORANGE T_CURSOR
}

theme_current() {
    local cur=""
    if [ -f "$STATE_FILE" ]; then
        cur=$(tr -d '[:space:]' <"$STATE_FILE" 2>/dev/null || true)
    fi
    theme_valid "$cur" || cur="$DEFAULT_THEME"
    printf '%s' "$cur"
}

# Replace every @@VAR@@ token in a template with the exported environment.
theme_render() {
    local src=$1 dest=$2 tmp
    [ -f "$src" ] || die "missing template: $src"
    mkdir -p "$(dirname "$dest")"
    tmp=$(mktemp) || die "mktemp failed"
    awk '
        {
            n = split($0, part, "@@")
            out = ""
            for (i = 1; i <= n; i++)
                out = out (i % 2 ? part[i] : (part[i] in ENVIRON ? ENVIRON[part[i]] : part[i]))
            print out
        }
    ' "$src" >"$tmp" && mv "$tmp" "$dest" || {
        rm -f "$tmp"
        die "failed to render $src"
    }
}

# Point <dir>/current.<ext> at <id>.<ext> without leaving a dangling link.
theme_link() {
    local dir=$1 id=$2 ext=$3
    [ -f "$dir/$id.$ext" ] || die "generated theme missing: $dir/$id.$ext"
    (cd "$dir" && ln -sfn "$id.$ext" "current.$ext")
}

theme_render_rofi() {
    local id=$1
    theme_render "$TEMPLATE_DIR/rofi.rasi.in" "$CONFIG_DIR/rofi/themes/$id.rasi"
    theme_link "$CONFIG_DIR/rofi/themes" "$id" rasi
}

theme_render_foot() {
    local id=$1
    theme_render "$TEMPLATE_DIR/foot.ini.in" "$CONFIG_DIR/foot/themes/$id.ini"
    theme_link "$CONFIG_DIR/foot/themes" "$id" ini
}

theme_render_kitty() {
    local id=$1
    theme_render "$TEMPLATE_DIR/kitty.conf.in" "$CONFIG_DIR/kitty/$id.conf"
    theme_link "$CONFIG_DIR/kitty" "$id" conf
}

theme_render_btop() {
    local id=$1
    theme_render "$TEMPLATE_DIR/btop.theme.in" "$CONFIG_DIR/btop/themes/$id.theme"
    theme_link "$CONFIG_DIR/btop/themes" "$id" theme
}

theme_render_waybar() {
    local id=$1
    theme_render "$TEMPLATE_DIR/waybar.css.in" "$CONFIG_DIR/waybar/themes/$id.css"
    theme_link "$CONFIG_DIR/waybar/themes" "$id" css
}

# Waybar cannot resolve colors inside pango markup from CSS, so the few modules
# that hardcode a hex get rewritten in place (keyed on position, not on the
# value that happens to be there now).
theme_waybar_modules() {
    local dir="$CONFIG_DIR/waybar/modules"
    local hex='#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]'

    _replace_first_hex() {
        local file=$1 color=$2 tmp
        [ -f "$file" ] || return 0
        tmp=$(mktemp) || return 1
        awk -v c="$color" -v re="$hex" '
            !done && match($0, re) {
                $0 = substr($0, 1, RSTART - 1) c substr($0, RSTART + RLENGTH)
                done = 1
            }
            { print }
        ' "$file" >"$tmp" && mv "$tmp" "$file" || rm -f "$tmp"
    }

    _replace_first_hex "$dir/hyprland/window.jsonc" "$T_FG_DIM"
    _replace_first_hex "$dir/custom/layout.jsonc" "$T_GREEN"

    local file="$dir/datetime.jsonc" tmp
    if [ -f "$file" ]; then
        tmp=$(mktemp) || return 1
        awk -v re="$hex" \
            -v aqua="$T_AQUA" -v fg="$T_FG" -v green="$T_GREEN" \
            -v yellow="$T_YELLOW" -v red="$T_RED" '
            /"months"/   { sub(re, aqua) }
            /"days"/     { sub(re, fg) }
            /"weeks"/    { sub(re, green) }
            /"weekdays"/ { sub(re, yellow) }
            /"today"/    { sub(re, red) }
            { print }
        ' "$file" >"$tmp" && mv "$tmp" "$file" || rm -f "$tmp"
    fi
}

# dunst has no include/import, so the colors are rewritten where they live.
theme_dunst() {
    local file="$CONFIG_DIR/dunst/dunstrc" tmp
    [ -f "$file" ] || return 0
    tmp=$(mktemp) || return 1
    awk -v bg="$T_BG" -v fg="$T_FG" -v dim="$T_FG_DIM" -v surface="$T_SURFACE" '
        /^[[:space:]]*\[/ { sec = $0; print; next }
        /^[[:space:]]*(#|$)/ { print; next }
        {
            key = ""
            if (match($0, /^[[:space:]]*[A-Za-z_][A-Za-z0-9_]*/))
                key = substr($0, RSTART, RLENGTH)
            gsub(/[[:space:]]/, "", key)

            urgency = (sec ~ /^[[:space:]]*\[urgency_(low|normal|critical)[[:space:]]*\]/)
            val = ""
            if (urgency && key == "background") val = bg
            else if (urgency && key == "foreground") val = (sec ~ /critical/ ? fg : dim)
            else if ((urgency || sec ~ /^[[:space:]]*\[global\]/) && key == "frame_color") val = surface

            if (val != "") {
                indent = ""
                if (match($0, /^[[:space:]]*/)) indent = substr($0, RSTART, RLENGTH)
                print indent key " = \"" val "\""
                next
            }
            print
        }
    ' "$file" >"$tmp" && mv "$tmp" "$file" || rm -f "$tmp"
}

theme_render_hypr() {
    theme_render "$TEMPLATE_DIR/theme-colors.lua.in" "$CONFIG_DIR/hypr/_theme_colors.lua"
}

# Apply a theme to every component. Does not reload anything.
theme_apply() {
    local id
    id=$(theme_resolve "$1") || die "unknown theme: $1"
    theme_valid "$id" || die "unknown theme: $1"

    theme_load "$id"

    theme_render_rofi "$id"
    theme_render_foot "$id"
    theme_render_kitty "$id"
    theme_render_btop "$id"
    theme_render_waybar "$id"
    theme_render_hypr

    theme_waybar_modules
    theme_dunst

    mkdir -p "$(dirname "$STATE_FILE")"
    printf '%s\n' "$id" >"$STATE_FILE"

    THEME_APPLIED_ID=$id
    THEME_APPLIED_NAME=$T_NAME
}

# Pick up the new colors without re-logging in.
theme_reload() {
    # waybar: the module files changed, so a full restart (same pattern as
    # ~/scripts/waybar-menu) is more reliable than a style-only signal.
    if pgrep -x waybar >/dev/null 2>&1; then
        local launcher="$CONFIG_DIR/hypr/scripts/launch-waybar.sh"
        pkill waybar >/dev/null 2>&1 || true
        sleep 0.4
        if [ -x "$launcher" ]; then
            "$launcher" >/dev/null 2>&1 &
        else
            waybar >/dev/null 2>&1 &
        fi
    fi

    # dunst: hot reload, no restart.
    if pgrep -x dunst >/dev/null 2>&1; then
        dunstctl reload >/dev/null 2>&1 || true
    fi

    # foot: only reloadable through the foot server; otherwise new windows.
    if [ -n "${XDG_RUNTIME_DIR:-}" ] && [ -S "${XDG_RUNTIME_DIR}/foot-${WAYLAND_DISPLAY:-wayland-1}.sock" ]; then
        footclient reload >/dev/null 2>&1 || true
    fi

    # hyprland: pick up _theme_colors.lua and any new keybind.
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl reload >/dev/null 2>&1 || true
    fi
}

theme_notify() {
    command -v notify-send >/dev/null 2>&1 || return 0
    notify-send 'Theme' "Colors set to <span color=\"$T_PURPLE\"><b>$T_NAME</b></span>" \
        -t 2200 -i dialog-information \
        --hint=string:x-dunst-stack-tag:theme &
}

# Five color swatches, used by the rofi picker rows.
theme_swatch() {
    printf '<span background="%s">   </span><span background="%s">   </span><span background="%s">   </span><span background="%s">   </span><span background="%s">   </span>' \
        "$T_BG" "$T_RED" "$T_YELLOW" "$T_GREEN" "$T_BLUE"
}
