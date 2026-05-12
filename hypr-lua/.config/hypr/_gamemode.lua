local gamemode_status = os.getenv("HOME") .. "/.cache/hypr_gamemode"
local f = io.open(gamemode_status, "r")
local is_gamemode = false
if f ~= nil then
    is_gamemode = true
    f:close()
end

return is_gamemode
