local config = require("config")
ngx.req.read_body()
local args, err = ngx.req.get_post_args()
if not args then
    ngx.say("failed to get post args: ", err)
    return
end

if args.password == config.password then
    local session = require "resty.session".start()
    session.data.logged = true
    session.save()
    ngx.say("ok")
end