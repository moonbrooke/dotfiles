-- # See https://wiki.hyprland.org/Configuring/Keywords/
local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd(powermenu))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.center())
hl.bind("F11", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("ALT + RETURN", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(zoom))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(gamemode))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(gaps))
hl.bind(mainMod .. " + BackSlash", hl.dsp.exec_cmd(keybinds_helper))
hl.bind(mainMod .. " + Slash", hl.dsp.exec_cmd(keybinds_helper))
-- # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
-- bind = $mainMod, Q, killactive,
-- bind = $mainMod, BackSpace, exec, $powermenu
-- bind = $mainMod, F, togglefloating,
-- bind = $mainMod, F, centerwindow,
-- bind = , F11, fullscreen, 0
-- bind = ALT, RETURN, fullscreen, 0
-- bind = $mainMod, Z, exec, $zoom
-- bind = $mainMod, G, exec, $gamemode
-- bind = $mainMod, B, exec, $gaps
-- bind = $mainMod, BackSlash, exec, $keybinds_helper
-- bind = $mainMod, Slash, exec, $keybinds_helper
--
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(filemanager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(cliphist))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(run))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(restart_waybar))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(bluetooth))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(wifi))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(wifi))
-- # Essentials
-- bind = $mainMod, RETURN, exec, $terminal
-- bind = $mainMod, E, exec, $fileManager
-- bind = $mainMod, SPACE, exec, $menu
-- bind = $mainMod, P, pseudo, # dwindle
-- bind = $mainMod, J, layoutmsg, togglesplit # dwindle
-- bind = $mainMod, V, exec, $cliphist
-- bind = $mainMod, R, exec, $run
-- bind = $mainMod SHIFT, R, exec, $restart_waybar
-- bind = $mainMod SHIFT, B, exec, $bluetooth
-- bind = $mainMod SHIFT, W, exec, $wifi
-- bind = $mainMod, N, exec, $wifi
--
hl.bind("Print", hl.dsp.exec_cmd(full_screenshot))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(select_screenshot))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(window_screenshot))
-- # Screenshots
-- bind = , Print, exec, $full_screenshot
-- bind = $mainMod, Print, exec, $select_screenshot
-- bind = $mainMod SHIFT, Print, exec, $window_screenshot
--
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Tab",  hl.dsp.window.cycle_next())
-- # Move focus with mainMod + arrow keys
-- bind = $mainMod, left, movefocus, l
-- bind = $mainMod, right, movefocus, r
-- bind = $mainMod, up, movefocus, u
-- bind = $mainMod, down, movefocus, d
-- bind = $mainMod, Tab, cyclenext
--
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "down" }))
-- # Move windows around workspaces
-- bind = $mainMod SHIFT, Left, movewindow, l # [hidden]
-- bind = $mainMod SHIFT, Right, movewindow, r # [hidden]
-- bind = $mainMod SHIFT, Up, movewindow, u # [hidden]
-- bind = $mainMod SHIFT, Down, movewindow, d # [hidden]
--
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end
-- # Switch workspaces with mainMod + [0-9]
-- bind = $mainMod, 1, workspace, 1
-- bind = $mainMod, 2, workspace, 2
-- bind = $mainMod, 3, workspace, 3
-- bind = $mainMod, 4, workspace, 4
-- bind = $mainMod, 5, workspace, 5
-- bind = $mainMod, 6, workspace, 6
-- bind = $mainMod, 7, workspace, 7
-- bind = $mainMod, 8, workspace, 8
-- bind = $mainMod, 9, workspace, 9
-- bind = $mainMod, 0, workspace, 10
--
-- # Move active window to a workspace with mainMod + SHIFT + [0-9]
-- bind = $mainMod SHIFT, 1, movetoworkspace, 1
-- bind = $mainMod SHIFT, 2, movetoworkspace, 2
-- bind = $mainMod SHIFT, 3, movetoworkspace, 3
-- bind = $mainMod SHIFT, 4, movetoworkspace, 4
-- bind = $mainMod SHIFT, 5, movetoworkspace, 5
-- bind = $mainMod SHIFT, 6, movetoworkspace, 6
-- bind = $mainMod SHIFT, 7, movetoworkspace, 7
-- bind = $mainMod SHIFT, 8, movetoworkspace, 8
-- bind = $mainMod SHIFT, 9, movetoworkspace, 9
-- bind = $mainMod SHIFT, 0, movetoworkspace, 10
--
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))
-- # Example special workspace (scratchpad)
-- bind = $mainMod, S, togglespecialworkspace, magic
-- bind = $mainMod SHIFT, S, movetoworkspace, special:magic
--
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
-- # Move through existing workspaces with mainMod + scroll or mainMod+crtl+shift + left/right arrow
-- bind = $mainMod, mouse_down, workspace, m+1
-- bind = $mainMod, mouse_up, workspace, m-1
-- bind = $mainMod+Ctrl SHIFT, right, workspace, r+1
-- bind = $mainMod+Ctrl SHIFT, left, workspace, r-1
--
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
-- # Move/resize windows with mainMod + LMB/RMB and dragging
-- bindm = $mainMod, mouse:272, movewindow
-- bindm = $mainMod, mouse:273, resizewindow
--
-- # Resize windows with mainMod + Ctrl + Arrow keys
-- bind = $mainMod+Ctrl, right, resizeactive, 50 0
-- bind = $mainMod+Ctrl, left, resizeactive, -50 0
-- bind = $mainMod+Ctrl, down, resizeactive, 0 50
-- bind = $mainMod+Ctrl, up, resizeactive, 0 -50
--
-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
-- # Laptop multimedia keys for volume and LCD brightness
-- bindel = ,XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
-- bindel = ,XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
-- # bindel = ,XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
-- bindel = ,XF86AudioMute, exec, pamixer -t && dunstify -i ~/.config/dunst/assets/$(pamixer --get-mute | grep -q "true" && echo "volume-mute.svg" || echo "volume.svg") -t 500 -r 2593 "Toggle Mute"
-- bindel = ,XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
-- bindel = ,XF86MonBrightnessUp, exec, brightnessctl s 10%+
-- bindel = ,XF86MonBrightnessDown, exec, brightnessctl s 10%-
--
-- # Requires playerctl
-- bindl = , XF86AudioNext, exec, playerctl next
-- bindl = , XF86AudioPause, exec, playerctl play-pause
-- bindl = , XF86AudioPlay, exec, playerctl play-pause
-- bindl = , XF86AudioPrev, exec, playerctl previous
