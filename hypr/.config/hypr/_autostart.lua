local utils = require("_utils")

--- Start every command in a list.
--- @param cmds string[]
local function exec_all(cmds)
    for _, cmd in ipairs(cmds) do
        hl.exec_cmd(cmd)
    end
end

local arch_cmds = {
    "~/.config/hypr/scripts/xdph-arch.sh",
    "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "dbus-update-activation-environment --systemd --all",
    "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP",
    "systemctl --user start hyprpolkitagent",
    'gsettings set org.gnome.desktop.interface gtk-theme "Dracula"',
    'gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"',
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "dunst -config $HOME/.config/dunst/dunstrc",
    "hypridle",
    "hyprsunset",
    "~/scripts/brightness restore",
    "awww-daemon",
    "fcitx5",
    "~/scripts/waybar-launch",
    "~/scripts/capslock",
    "udiskie --automount --no-notify --no-tray",
}

local void_cmds = {
    "dbus-update-activation-environment --all",
    "~/.config/hypr/scripts/xdph-void.sh",
    "/usr/libexec/hyprpolkitagent",
    'gsettings set org.gnome.desktop.interface gtk-theme "Dracula"',
    'gsettings set org.gnome.desktop.interface cursor-theme "Adwaita"',
    "wl-paste --type text --watch cliphist store",
    "wl-paste --type image --watch cliphist store",
    "dunst -config $HOME/.config/dunst/dunstrc",
    "sh -c 'pgrep -x pipewire >/dev/null || pipewire &'",
    "hyprsunset",
    "~/scripts/brightness restore",
    "awww-daemon",
    "fcitx5",
    "~/scripts/waybar-launch",
    "~/scripts/capslock",
    "udiskie --automount --no-notify --no-tray",
}

hl.on("hyprland.start", function ()
    local id = utils.distro_id()

    if id == "arch" then
        exec_all(arch_cmds)
    elseif id == "void" then
        exec_all(void_cmds)
    end
end)
