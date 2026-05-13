local animation_status = os.getenv("HOME") .. "/.cache/hypr_animation"
local f = io.open(animation_status, "r")
local is_animation = false
if f ~= nil then
    is_animation = true
    f:close()
end

return is_animation
