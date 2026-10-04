local layouts = { "dwindle", "master", "scrolling", "monocle" }

return function()
    local current_layout = hl.get_config("general.layout")
    local next_index = 1

    for i, layout in ipairs(layouts) do
        if layout == current_layout then
            next_index = (i % #layouts) + 1
            break
        end
    end

    local next_layout = layouts[next_index]

    hl.config({ general = { layout = next_layout } })

    local cmd = string.format(
        "notify-send 'Settings' 'Layout switched to: <span color=\"#9ece6a\"><b>%s</b></span>' -t 2500 -i dialog-information &",
        string.upper(next_layout)
    )

    os.execute(cmd)
    os.execute("pkill -RTMIN+8 waybar &")
end
