local upload = require("resty.upload")
local cjson = require("cjson")
ngx.header['Server'] = 'wiiu-screenshot-server code by stan'

local path = ngx.var.uri
local method = ngx.req.get_method()
local ua = ngx.var.http_user_agent
ngx.say(ua)

local chunk_size = 4096
-- local form, err = upload:new(chunk_size)
-- if not form then
--     ngx.log(ngx.ERR, "failed to new upload: ", err)
--     ngx.exit(500)
-- end

