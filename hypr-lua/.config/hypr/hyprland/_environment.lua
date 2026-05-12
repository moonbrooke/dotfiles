hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GTK_THEME", "Dracula")
-- # env = XCURSOR_THEME,CursorNameHere
hl.env("XCURSOR_SIZE", "22")
hl.env("HYPRCURSOR_SIZE", "22")

-- hl.env("GDK_BACKEND", "wayland", "x11", "*")
-- env = QT_QPA_PLATFORM,wayland;xcb
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")
-- # env = QT_QPA_PLATFORMTHEME,qt5ct # Tells Qt based applications to pick your theme from qt5ct, use with Kvantum.
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("LIBVA_DRIVER_NAME", "nvidia")

hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "wayland")
hl.env("OZONE_PLATFORM", "wayland")

hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
