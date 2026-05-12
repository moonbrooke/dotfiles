hl.on("hyprland.start", function ()
    hl.exec_cmd("~/.config/hypr/scripts/xdph.sh")
    hl.exec_cmd("systemctl --user import-environment $(env | cut -d'=' -f 1)")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Dracula'")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("dunst -config ~/.config/dunst/dunstrc")
    hl.exec_cmd("swaybg -i ~/Pictures/Wallpapers/wallhaven-9omr8k.png")
    hl.exec_cmd("waybar")
end)

-- # exec-once = ~/.config/hypr/scripts/polkit.sh # authentication dialogue for GUI apps
-- # exec-once = $terminal
-- # exec-once = nm-applet &
-- # exec-once = hyprpaper
-- # exec-once = fcitx5 &
