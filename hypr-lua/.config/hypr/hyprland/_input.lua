hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },

        repeat_rate = 35,
        repeat_delay = 200,
    },
})

-- cursor {
--     # this ensures your mouse cursor doesn't glitch out
--     no_hardware_cursors = false
-- }

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

hl.device({
    name        = "instant-usb-gaming-mouse-",
    sensitivity = -0.5,
})
