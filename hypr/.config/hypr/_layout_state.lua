local utils = require("_utils")

local M = {
    layouts = { "dwindle", "master", "scrolling", "monocle" },
    default = "dwindle",
}

--- Read the persisted layout from $HOME/.cache, falling back to default
--- @return string
function M.get()
    local saved = utils.cache_read("hypr_layout")

    if saved then
        for _, layout in ipairs(M.layouts) do
            if layout == saved then
                return layout
            end
        end
    end

    return M.default
end

--- Persist a layout so it survives restarts and config reloads
--- @param layout string
--- @return boolean success
function M.set(layout)
    return utils.cache_write("hypr_layout", layout)
end

return M
