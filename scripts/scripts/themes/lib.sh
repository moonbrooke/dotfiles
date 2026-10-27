#!/usr/bin/env bash
#
# ~/scripts/themes/lib.sh -- shared helpers for the color theme switcher.
#
# Colors live in palettes/<id>.conf as T_* variables. Everything the desktop
# renders (rofi themes, kitty/btop color files, the waybar @define-color block,
# dunst urgency colors) is generated from those, so a palette is the only thing
# that ever needs editing by hand.
#
# Sourced by ~/scripts/theme and by any script that wants a live color, e.g.
#     . "$HOME/scripts/themes/lib.sh"
#     theme_load "$(theme_current)"
#     notify-send 'Settings' "Done <span color=\"$T_GREEN\">OK</span>"

THEMES_DIR="$HOME/scripts/themes"
PALETTE_DIR="$THEMES_DIR/palettes"
TEMPLATE_DIR="$THEMES_DIR/templates"
STATE_FILE="$HOME/.cache/theme_state"
HYPR_THEME_FILE="$HOME/.cache/theme_colors.lua"
DEFAULT_THEME="tokyonight"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}"

# Ordered theme list for menus and `theme list`.
THEME_IDS=(
    tokyonight
    tokyodawn
)

# Palette variables every palette must define.
THEME_VARS=(
    T_NAME T_MODE
    T_BG T_BG_ALT T_SURFACE
    T_FG T_FG_DIM T_FG_MUTED
    T_ACCENT
    T_BORDER_ACTIVE_1 T_BORDER_ACTIVE_2 T_BORDER_INACTIVE
    T_RED T_GREEN T_YELLOW T_BLUE T_PURPLE T_AQUA T_ORANGE
    T_CURSOR
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
# and loose aliases, all case/dash/space insensitive: "Dawn", "tokyo dawn" and
# "tokyo-dawn" all resolve to tokyodawn.
theme_resolve() {
    [ -n "$1" ] || return 1
    local want name id
    want=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]' | tr '_ ' '--')

    case "$want" in
        tokyonight|tokyo-night|night)
            printf 'tokyonight'
            return 0
            ;;
        tokyodawn|tokyo-dawn|dawn)
            printf 'tokyodawn'
            return 0
            ;;
    esac

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
    local id=$1 v name val
    [ -f "$PALETTE_DIR/$id.conf" ] || die "unknown theme: $id"

    for v in "${THEME_VARS[@]}"; do
        unset "$v"
    done
    unset T_ID T_SECTION
    for v in "${THEME_VARS[@]}"; do
        unset "${v}_N"
    done

    # shellcheck disable=SC1090
    . "$PALETTE_DIR/$id.conf"

    for v in "${THEME_VARS[@]}"; do
        if [ -z "${!v:-}" ]; then
            die "palette '$id' is missing $v"
        fi
    done

    export T_ID="$id"

    if [ "$T_MODE" = "light" ]; then
        export T_SECTION="light"
    else
        export T_SECTION="dark"
    fi

    # kitty/foot/hyprland want bare hex (no leading #)
    for v in BG BG_ALT SURFACE FG FG_DIM FG_MUTED ACCENT \
        BORDER_ACTIVE_1 BORDER_ACTIVE_2 BORDER_INACTIVE \
        RED GREEN YELLOW BLUE PURPLE AQUA ORANGE CURSOR; do
        name="T_${v}"
        val=${!name}
        printf -v "T_${v}_N" '%s' "${val#\#}"
        export "T_${v}_N"
    done

    export T_NAME T_MODE T_BG T_BG_ALT T_SURFACE T_FG T_FG_DIM T_FG_MUTED
    export T_ACCENT T_BORDER_ACTIVE_1 T_BORDER_ACTIVE_2 T_BORDER_INACTIVE
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
    chmod 644 "$dest" 2>/dev/null || true
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
}

theme_render_kitty() {
    local id=$1
    theme_render "$TEMPLATE_DIR/kitty.conf.in" "$CONFIG_DIR/kitty/$id.conf"
}

theme_render_btop() {
    local id=$1
    theme_render "$TEMPLATE_DIR/btop.theme.in" "$CONFIG_DIR/btop/themes/$id.theme"
}

theme_render_waybar() {
    local id=$1
    theme_render "$TEMPLATE_DIR/waybar.css.in" "$CONFIG_DIR/waybar/themes/$id.css"
}

theme_render_hypr() {
    mkdir -p "$(dirname "$HYPR_THEME_FILE")"
    theme_render "$TEMPLATE_DIR/theme-colors.lua.in" "$HYPR_THEME_FILE"
}

# Render both per-theme variants, point the current.* symlinks at <id>, and
# write the hyprland Lua table for the active theme.
theme_render_all() {
    local id
    for id in "${THEME_IDS[@]}"; do
        theme_load "$id"
        theme_render_rofi "$id"
        theme_render_kitty "$id"
        theme_render_btop "$id"
        theme_render_waybar "$id"
    done

    theme_load "$1"
    theme_render_hypr

    theme_link "$CONFIG_DIR/rofi/themes" "$1" rasi
    theme_link "$CONFIG_DIR/kitty" "$1" conf
    theme_link "$CONFIG_DIR/btop/themes" "$1" theme
    theme_link "$CONFIG_DIR/waybar/themes" "$1" css
}

# Foot has no include support we want to rely on: keep both [colors-dark] and
# [colors-light] statically in foot.ini and just flip initial-color-theme.
theme_foot() {
    local file="$CONFIG_DIR/foot/foot.ini" section tmp
    [ -f "$file" ] || return 0

    if [ "$T_MODE" = "light" ]; then
        section="light"
    else
        section="dark"
    fi

    tmp=$(mktemp) || return 1
    awk -v section="$section" '
        BEGIN { done = 0; in_main = 1 }
        /^[[:space:]]*\[/ {
            if (!done && in_main) {
                print "initial-color-theme = " section
                done = 1
            }
            in_main = 0
        }
        /^[[:space:]]*initial-color-theme[[:space:]]*=/ {
            print "initial-color-theme = " section
            done = 1
            next
        }
        { print }
        END {
            if (!done)
                print "initial-color-theme = " section
        }
    ' "$file" >"$tmp" && mv "$tmp" "$file" || rm -f "$tmp"
    chmod 644 "$file" 2>/dev/null || true
}

# Waybar cannot resolve colors inside pango markup from CSS, so the few modules
# that hardcode a hex get rewritten in place (keyed on position, not on the
# value that happens to be there now).
theme_waybar_modules() {
    local dir="$CONFIG_DIR/waybar/modules"
    local hex='#[0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F][0-9a-fA-F]'

    _theme_replace_first_hex() {
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
        chmod 644 "$file" 2>/dev/null || true
    }

    _theme_replace_first_hex "$dir/hyprland/window.jsonc" "$T_FG"
    _theme_replace_first_hex "$dir/custom/layout.jsonc" "$T_GREEN"
    _theme_replace_first_hex "$dir/custom/layout-double.jsonc" "$T_GREEN"

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
        chmod 644 "$file" 2>/dev/null || true
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
    chmod 644 "$file" 2>/dev/null || true
}

# Apply a theme to every component. Does not reload anything.
theme_apply() {
    local id
    id=$(theme_resolve "$1") || die "unknown theme: $1"
    theme_valid "$id" || die "unknown theme: $1"

    theme_render_all "$id"
    theme_foot
    theme_waybar_modules
    theme_dunst

    mkdir -p "$(dirname "$STATE_FILE")"
    printf '%s\n' "$id" >"$STATE_FILE"

    THEME_APPLIED_ID=$id
    THEME_APPLIED_NAME=$T_NAME
}

# Pick up the new colors without re-logging in.
theme_reload() {
    local foot_signal

    # hyprland: update borders immediately, then reload for any other
    # theme-aware Lua (the reload re-reads ~/.cache/theme_colors.lua too).
    if command -v hyprctl >/dev/null 2>&1; then
        hyprctl eval "hl.config({
  general = {
    col = {
      active_border = {
        colors = {'rgb($T_BORDER_ACTIVE_1_N)', 'rgb($T_BORDER_ACTIVE_2_N)'},
        angle = 45
      },
      inactive_border = 'rgb($T_BORDER_INACTIVE_N)'
    }
  },
  decoration = {
    shadow = {
      color = 'rgb($T_FG_N)',
      color_inactive = 'rgba(${T_FG_N}00)'
    }
  }
})" >/dev/null 2>&1 || true
        hyprctl reload >/dev/null 2>&1 || true
    fi

    # waybar: SIGUSR2 is bound to reload by default, preserving bar state.
    if pgrep -x waybar >/dev/null 2>&1; then
        pkill -USR2 -x waybar >/dev/null 2>&1 || true
    fi

    # dunst: hot reload, no restart.
    if command -v dunstctl >/dev/null 2>&1 && pgrep -x dunst >/dev/null 2>&1; then
        dunstctl reload >/dev/null 2>&1 || true
    fi

    # kitty: SIGUSR1 reloads the config (including current.conf) for all windows.
    if pgrep -x kitty >/dev/null 2>&1; then
        pkill -USR1 -x kitty >/dev/null 2>&1 || true
    fi

    # foot: SIGUSR1 selects [colors-dark], SIGUSR2 selects [colors-light].
    if [ "$T_MODE" = "light" ]; then
        foot_signal="USR2"
    else
        foot_signal="USR1"
    fi
    if pgrep -x foot >/dev/null 2>&1; then
        pkill "-$foot_signal" -x foot >/dev/null 2>&1 || true
    fi
    if pgrep -x footclient >/dev/null 2>&1; then
        pkill "-$foot_signal" -x footclient >/dev/null 2>&1 || true
    fi

    # btop: hot reloads config + active theme.
    if pgrep -x btop >/dev/null 2>&1; then
        pkill -USR2 -x btop >/dev/null 2>&1 || true
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
