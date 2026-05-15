local layouts = { "dwindle", "master", "scrolling", "monocle" }
local img = "~/.config/hypr/img/window.png"

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
        "notify-send 'Layout Changed' 'Switched to: <b>%s</b>' -t 2500 -i dialog-information &",
        next_layout
    )
    os.execute(cmd)
end
