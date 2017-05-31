local upload = require("resty.upload")
local cjson = require("cjson")
ngx.header['Server'] = 'wiiu-screenshot-server code by stan'

local path = ngx.var.uri
local method = ngx.req.get_method()

local ua = ngx.var.http_user_agent
local res = nil
if string.find(ua, "(Nintendo WiiU)") then
    res = ngx.location.capture('/upload')
else
    res = ngx.location.capture('/home')
end
ngx.say(res.body)

-- local chunk_size = 4096
-- local form, err = upload:new(chunk_size)
-- if not form then
--     ngx.log(ngx.ERR, "failed to new upload: ", err)
--     ngx.exit(500)
-- end

