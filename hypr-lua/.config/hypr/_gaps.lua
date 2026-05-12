local gaps_status = os.getenv("HOME") .. "/.cache/hypr_gaps"
local f = io.open(gaps_status, "r")
local gaps = false

if f ~= nil then
    gaps = true
    f:close()
end

-- Export the result
return gaps
