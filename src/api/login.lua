local config = require("config")
ngx.req.read_body()
local args, err = ngx.req.get_post_args()
if not args or args.password ~= config.password then
    ngx.say("failed to login")
else
    local session = require "resty.session".start()
    session.data.logged = true
    session:save()
    ngx.say("ok")
end
