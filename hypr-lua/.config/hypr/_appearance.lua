local gaps = require("_gap")
local is_animation = require("_animation_toggle")

hl.config({
    general = {
        gaps_in = gaps and 5 or 0,
        gaps_out = gaps and 10 or 0,
        border_size = 3,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",

        col = {
            active_border = { colors = {"rgb(f7768e)", "rgb(bb9af7)"}, angle = 45 },
            inactive_border = "rgb(414868)",
        },
    },

    decoration = {
        rounding = 0,
        -- rounding_power = 2,

        active_opacity = 0.95,
        inactive_opacity = 0.95,

        shadow = {
            enabled = true,
            range = 5,
            render_power = 4,
            color = 0xff1a1b26,
        },

        blur = {
            enabled = true,
            size = 5,
            passes = 1,
            vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = is_animation,
    },
})
