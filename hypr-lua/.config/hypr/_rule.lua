hl.window_rule({ match = { title = "Bluetooth" }, float = true })
hl.window_rule({ match = { title = "floating_wifi" }, size = {800, 800}, float = true })
hl.window_rule({ match = { class = "org.prismlauncher.PrismLauncher" }, float = true })
hl.window_rule({ match = { class = "UltimMC" }, float = true })
hl.window_rule({ match = { class = "minecraft-launcher" }, float = true })
hl.window_rule({ match = { title = "^(.*Minecraft.*)$" }, float = true })
hl.window_rule({ match = { class = "steam" }, float = true })
hl.window_rule({ match = { class = "^(steam_app_.*)$" }, float = true })
hl.window_rule({ match = { class = "org.gnome.nautilus" }, float = true })
hl.window_rule({ match = { class = "org.gnome.Loupe" }, float = true })
hl.window_rule({ match = { class = "com.github.rafostar.Clapper" }, float = true })
hl.window_rule({ match = { class = "com.obsproject.Studio" }, workspace = 4, float = false })

hl.window_rule({ match = { title = "^(.*YouTube.*)$" }, opacity = "1.0" })

-- windowrule = {
--     -- Floats
--     "float on, match:class (org.telegram.desktop)",
--     "float on, match:class (discord)",
--     "float on, match:class (net.tagaini.tagainijisho)",
--     "float on, match:class (vlc)",
--     "float on, match:title (Picture-in-Picture)",
--     "float on, match:class (org.pulseaudio.pavucontrol)",
--     "float on, match:class (lutris)",
--     "float on, match:class (org.gnome.Calculator)",
--     "float on, match:class (imv)",
--
--     -- Workspaces & Floats
--     "float on, workspace 3, match:class (com.github.wwmm.easyeffects)",
--     "workspace 2, match:class (Mailspring)",
--     "float on, workspace 2, match:class (LM-Studio)",
--
--     -- Opacity
--     "opacity 1.0 override 1.0 override, match:title ^(.*Twitch.*)$",
--     "opacity 1.0 override 1.0 override, match:title (Picture-in-Picture)",
--     "opacity 1.0 override 1.0 override, match:class (obs)",
--     "opacity 1.0 override 1.0 override, match:class (org.gnome.Loupe)",
--     "opacity 1.0 override 1.0 override, match:class (com.github.rafostar.Clapper)",
--     "opacity 1.0 override 1.0 override, match:class (vlc)",
--     "opacity 1.0 override 1.0 override, match:title ^(.*Minecraft.*)$",
--     "opacity 1.0 override 1.0 override, match:class (com.bitwig.BitwigStudi)",
--     "opacity 1.0 override 1.0 override, match:class ^(steam_app_.*)$"
-- },

hl.workspace_rule({ workspace = "1", persistent = true, monitor = "eDP-1", default = true, })
hl.workspace_rule({ workspace = "2", persistent = true, monitor = "eDP-1", default = true, })
hl.workspace_rule({ workspace = "3", persistent = true, monitor = "eDP-1", default = true, })
hl.workspace_rule({ workspace = "4", persistent = true, monitor = "HDMI-A-1", default = true, })
