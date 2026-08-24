hl.config({
    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = {
            natural_scroll = true,
        },
        repeat_rate = 35,
        repeat_delay = 200,
    },
    cursor = {
        zoom_factor = 1,
        zoom_rigid = false,
        zoom_disable_aa = true,
        hotspot_padding = 1,
        no_hardware_cursors = false,
        inactive_timeout = 2,
        no_warps = false,
        persistent_warps = true,
    },
    gestures = {
        workspace_swipe_touch = false,
    },
    xwayland = {
        force_zero_scaling = true,
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name = "instant-usb-gaming-mouse-",
    sensitivity = -0.5,
})
