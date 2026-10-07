local utils = require("_utils")

-- General
hl.window_rule({ match = { title = "Bluetooth" }, float = true })
hl.window_rule({ match = { title = "floating_impala" }, size = {800, 800}, float = true })
hl.window_rule({ match = { class = "org.gnome.nautilus" }, float = true })
hl.window_rule({ match = { class = "org.gnome.Loupe" }, float = true })
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true })
hl.window_rule({ match = { class = "com.github.rafostar.Clapper" }, float = true })
hl.window_rule({ match = { class = "com.github.wwmm.easyeffects" }, workspace = 3, float = true })
hl.window_rule({ match = { class = "com.obsproject.Studio" }, workspace = 2, float = false })
hl.window_rule({ match = { class = "org.telegram.desktop" }, workspace = 2 })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true })
hl.window_rule({ match = { class = "net.tagaini.tagainijisho" }, float = true })
hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true })
hl.window_rule({ match = { class = "discord" }, float = true })
hl.window_rule({ match = { class = "vlc" }, opacity = "1.0 override", float = true })
hl.window_rule({ match = { class = "imv" }, float = true })
hl.window_rule({ match = { class = "LM-Studio" }, workspace = 2, float = true })
hl.window_rule({ match = { class = "Mailspring" }, workspace = 2, float = false })
hl.window_rule({ match = { class = "org.qbittorrent.qBittorrent" }, workspace = 2, float = false })
hl.window_rule({ match = { title = "^(.*YouTube.*)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { title = "^(.*Twitch.*)$" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "io.github.celluloid_player.Celluloid" }, opacity = "1.0 override" })
hl.window_rule({ match = { class = "^(.*keyviz.*)$" }, opacity = "1.0 override", decorate = false, no_blur = true, no_shadow = true, opaque = false, rounding = 0, no_dim = true })
hl.window_rule({ match = { class = "thunar", title = "^(.*File Operation Progress.*)$" }, size = {476, 520}, float = true })
hl.window_rule({ match = { class = "thunar", title = "^(.*Rename \".*)$" }, size = {476, 520}, float = true })
hl.window_rule({ match = { class = "foot" }, persistent_size = true })
hl.window_rule({ match = { class = "ai.storyteller.photocraft" }, opacity = "1.0 override" })

-- Games
hl.window_rule({ match = { class = "org.prismlauncher.PrismLauncher" }, float = true })
hl.window_rule({ match = { class = "minecraft-launcher" }, float = true })
hl.window_rule({ match = { title = "^(.*Minecraft.*)$" }, opacity = "1.0 override", workspace = 3, float = false })
hl.window_rule({ match = { class = "steam" }, float = true })
hl.window_rule({ match = { class = "^(steam_app_.*)$" }, opacity = "1.0 override", float = true })
hl.window_rule({ match = { class = "lutris" }, float = true })

-- Workspaces
-- Only one workspace may have default = true; others remain persistent.

local LAPTOP = "eDP-1"
local EXTERNAL = "HDMI-A-1"
local EXTERNAL_PINS = { "5", "6" }

--- Register a persistent workspace.
--- @param workspace string
--- @param monitor string Hyprland output name
--- @param extra table|nil additional workspace rule fields
local function workspace_rule(workspace, monitor, extra)
    local spec = { workspace = workspace, persistent = true }

    if utils.output_connected(monitor) ~= false then
        spec.monitor = monitor
    end

    for key, value in pairs(extra or {}) do
        spec[key] = value
    end

    hl.workspace_rule(spec)
end

local function restore_external_pins()
    if hl.get_monitor(EXTERNAL) == nil then
        return
    end

    local active = hl.get_active_workspace()
    local active_id = active and tostring(active.id) or nil

    for _, id in ipairs(EXTERNAL_PINS) do
        local ws = hl.get_workspace(id)
        local misplaced = ws ~= nil and ws.monitor ~= nil and ws.monitor.name ~= EXTERNAL

        -- Never yank the workspace the user is looking at to the other screen.
        if misplaced and active_id ~= id then
            hl.dsp.workspace.move({ workspace = id, monitor = EXTERNAL, no_follow = true })
        end
    end
end

hl.on("monitor.added", function()
    -- Let the new output finish initialising before reassigning workspaces.
    hl.timer(restore_external_pins, { timeout = 250, type = "oneshot" })
end)

workspace_rule("1", LAPTOP, { default = true })
workspace_rule("2", LAPTOP)
workspace_rule("3", LAPTOP)
workspace_rule("4", LAPTOP)

for _, id in ipairs(EXTERNAL_PINS) do
    workspace_rule(id, EXTERNAL)
end
