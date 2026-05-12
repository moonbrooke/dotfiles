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
        no_hardware_cursors = false,
    },
    gestures = {
        workspace_swipe_touch = false,
    },
})

hl.device({
    name = "instant-usb-gaming-mouse-",
    sensitivity = -0.5,
})
