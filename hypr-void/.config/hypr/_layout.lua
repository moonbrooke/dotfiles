local state = require("_layout_state")

--- Apply a layout, persist it, and refresh the waybar module
--- @param layout string
local function apply(layout)
    hl.config({ general = { layout = layout } })
    state.set(layout)

    local cmd = string.format(
        "notify-send 'Settings' 'Layout switched to: <span color=\"#9ece6a\"><b>%s</b></span>' -t 2500 --hint=string:x-dunst-stack-tag:layout -i dialog-information &",
        string.upper(layout)
    )

    os.execute(cmd)
    os.execute("pkill -RTMIN+8 waybar &")
end

return {
    --- Cycle to the next layout in the list
    cycle = function()
        local layouts = state.layouts
        local current_layout = hl.get_config("general.layout")
        local next_index = 1

        for i, layout in ipairs(layouts) do
            if layout == current_layout then
                next_index = (i % #layouts) + 1
                break
            end
        end

        apply(layouts[next_index])
    end,

    --- Force the layout back to the default
    reset = function()
        apply(state.default)
    end,
}
