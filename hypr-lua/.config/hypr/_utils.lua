local M = {}

--- Check if a cache/state file exists.
--- @param path string absolute path
--- @return boolean
function M.cache_exists(path)
    local f = io.open(path, "r")
    if f ~= nil then
        f:close()
        return true
    end
    return false
end

--- Get cache file path under $HOME/.cache
--- @param name string filename (e.g. "hypr_gaps")
--- @return string
function M.cache_path(name)
    return os.getenv("HOME") .. "/.cache/" .. name
end

return M
