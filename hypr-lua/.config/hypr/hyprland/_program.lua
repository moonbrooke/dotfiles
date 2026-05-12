local terminal = "foot"
local filemanager = "thunar"
local menu = "pkill rofi || rofi -modes 'drun' -show drun -display-drun 'Menu' -display-run 'Run' -display-window 'Window' -show-icons -auto-close"

-- $terminal = foot
-- $fileManager = thunar
-- $menu = pkill rofi || rofi -modes "drun" -show drun -display-drun "Menu" -display-run "Run" -display-window "Window" -show-icons -auto-close
local full_screenshot = "~/.config/hypr/scripts/screenshot.sh full"
local select_screenshot = "~/.config/hypr/scripts/screenshot.sh select"
local window_screenshot = "~/.config/hypr/scripts/screenshot.sh window"
local powermenu = "~/.config/hypr/scripts/power.sh"
local zoom = "~/.config/hypr/bin/hypr-zoom -duration=100 -easing=InOutQuad -interp=Linear -target=2.0"
local cliphist = "pkill rofi || cliphist list | rofi -dmenu -p 'Clipboard' -theme ~/.config/rofi/clipboard.rasi | cliphist decode | wl-copy"
local run = "pkill rofi || rofi -modes 'run' -show run -display-drun 'Menu' -display-run 'Run' -display-window 'Window' -show-icons -auto-close"
local restart_waybar = "pkill waybar; waybar &"
local wifi = "foot -T 'floating_wifi' -e wifitui"
local gamemode = "~/.config/hypr/scripts/gamemode.sh"
local gaps = "~/.config/hypr/scripts/gaps.sh"
local keybinds_helper = "pkill rofi || ~/.config/hypr/scripts/keybinds.sh"
