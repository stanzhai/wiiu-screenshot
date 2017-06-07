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

function _M.upload_file_to_qiniu(file)
    local config = require "config"
    local cmd = 'qshell account ' .. config.qiniu.ak .. ' ' .. config.qiniu.sk .. ';'
    cmd = cmd .. 'qshell fput images wiiu/' .. file .. ' ./upload/' .. file
    os.execute(cmd)
end

return _M