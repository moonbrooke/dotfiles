local utils = require("_utils")
local gaps_enabled = require("_gap")
local is_animation = require("_animation_toggle")

--- Read gap value from $HOME/.cache, falling back to default
--- @param name string cache filename (eg "hypr_gaps_in")
--- @param default integer fallback value
--- @return integer
local function cached_gap(name, default)
    local f = io.open(utils.cache_path(name), "r")
    if f then
        local v = tonumber(f:read("*l"))
        f:close()
        if v ~= nil and v >= 0 and math.floor(v) == v then
            return v
        end
    end
    return default
end

local gaps_in_value = cached_gap("hypr_gaps_in", 5)
local gaps_out_value = cached_gap("hypr_gaps_out", 10)

hl.config({
    general = {
        gaps_in = gaps_enabled and gaps_in_value or 0,
        gaps_out = gaps_enabled and gaps_out_value or 0,
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
