-- Programs
local terminal = "foot"
local file_manager = "thunar"
local browser = "firefox-esr"
local menu = 'pkill rofi || rofi -modes "drun" -show drun -display-drun "Menu" -display-run "Run" -display-window "Window" -show-icons -auto-close'
local full_screenshot = "~/.config/hypr/scripts/screenshot.sh full"
local select_screenshot = "~/.config/hypr/scripts/screenshot.sh select"
local window_screenshot = "~/.config/hypr/scripts/screenshot.sh window"
local power_menu = "~/.config/hypr/scripts/power.sh"
local cliphist = 'pkill rofi || cliphist list | rofi -dmenu -p "Clipboard" -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy'
local run = 'pkill rofi || rofi -modes "run" -show run -display-drun "Menu" -display-run "Run" -display-window "Window" -show-icons -auto-close'
local restart_waybar = "pkill waybar; waybar &"
local wifi = 'foot -T "floating_wifi" -e wifitui'
local gamemode = "~/.config/hypr/scripts/gamemode.sh"
local gaps = "~/.config/hypr/scripts/gaps.sh"
local notes = "~/scripts/rofi-notes.sh"
local keybinds_helper = "pkill rofi || ~/.config/hypr/scripts/keybinds.sh"
local emoji = "~/.config/hypr/scripts/emoji.sh"

local mainMod = "SUPER"

hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + BackSpace", hl.dsp.exec_cmd(power_menu))
hl.bind(mainMod .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.center())
hl.bind("F11", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind("ALT + RETURN", hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd(gamemode))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(gaps))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(notes))
hl.bind(mainMod .. " + BackSlash", hl.dsp.exec_cmd(keybinds_helper))
hl.bind(mainMod .. " + Slash", hl.dsp.exec_cmd(keybinds_helper))

-- Zoom
hl.bind(mainMod .. " + Z", function()
    local zoom = hl.get_config("cursor.zoom_factor") or 1
    hl.config({ cursor = { zoom_factor = zoom + 1 } })
end)

hl.bind(mainMod .. " + SHIFT + Z", function()
    hl.config({ cursor = { zoom_factor = 1 } })
end)

-- Essentials
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(cliphist))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(run))
hl.bind(mainMod .. " + Period", hl.dsp.exec_cmd(emoji))
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd(restart_waybar))
-- hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(bluetooth))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(wifi))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(wifi))

-- Screenshots
hl.bind("Print", hl.dsp.exec_cmd(full_screenshot))
hl.bind(mainMod .. " + Print", hl.dsp.exec_cmd(select_screenshot))
hl.bind(mainMod .. " + SHIFT + Print", hl.dsp.exec_cmd(window_screenshot))

-- Move focus
hl.bind(mainMod .. " + Left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + Right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + Up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + Down",  hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + Tab", hl.dsp.window.cycle_next())
hl.bind(mainMod .. " + Tab", hl.dsp.window.bring_to_top())
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.window.cycle_next({ next = false }))
hl.bind(mainMod .. " + SHIFT + Tab", hl.dsp.window.bring_to_top())

-- Move windows around workspaces
hl.bind(mainMod .. " + SHIFT + Left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + Right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + Up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + Down",  hl.dsp.window.move({ direction = "down" }))

-- Switch and move active window to workspaces
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Special workspace
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
-- mainMod .. "+Ctrl SHIFT, right, workspace, r+1",
-- mainMod .. "+Ctrl SHIFT, left, workspace, r-1",

-- Resize windows with mainMod + Ctrl + Arrow keys
-- mainMod .. "+Ctrl, right, resizeactive, 50 0",
-- mainMod .. "+Ctrl, left, resizeactive, -50 0",
-- mainMod .. "+Ctrl, down, resizeactive, 0 50",
-- mainMod .. "+Ctrl, up, resizeactive, 0 -50"

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

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
