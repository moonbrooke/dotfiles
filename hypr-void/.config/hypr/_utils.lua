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

--- Read the first line of a cache file under $HOME/.cache
--- @param name string filename (e.g. "hypr_layout")
--- @return string|nil trimmed value, or nil if the file is missing/empty
function M.cache_read(name)
    local f = io.open(M.cache_path(name), "r")
    if f == nil then
        return nil
    end

    local v = f:read("*l")
    f:close()

    if v == nil then
        return nil
    end

    v = v:gsub("^%s+", ""):gsub("%s+$", "")

    if v == "" then
        return nil
    end

    return v
end

--- Write a value to a cache file under $HOME/.cache
--- @param name string filename (e.g. "hypr_layout")
--- @param value string
--- @return boolean success
function M.cache_write(name, value)
    local f = io.open(M.cache_path(name), "w")
    if f == nil then
        return false
    end

    f:write(value, "\n")
    f:close()

    return true
end

--- Check whether a DRM connector is currently plugged in.
--- @param name string Hyprland output name
--- @return boolean|nil true/false, or nil if it cannot be determined
function M.output_connected(name)
    local pipe = io.popen("cat /sys/class/drm/card*-" .. name .. "/status 2>/dev/null")
    if not pipe then
        return nil
    end

    local status = pipe:read("*a")
    pipe:close()

    if status == nil then
        return nil
    end

    -- Exact match, not find(): "disconnected" also contains "connected".
    return status:gsub("%s+", "") == "connected"
end

return M
