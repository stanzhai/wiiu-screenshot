local lfs = require("lfs")
local _M = {}

function _M.split(str, s)
    local t = {}
    for m in string.gmatch(str, "([^" .. s .. "]+)") do
        table.insert(t, m)
    end
    return t
end

function _M.get_files(dir)
    local t = {}
    for file in lfs.dir(dir) do
        if file ~= "." and file ~= ".." then
            table.insert(t, file)
        end
    end
    return t
end

return _M