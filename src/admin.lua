local session = require("resty.session").open()
local res = nil
if session.data.logged then
    res = ngx.location.capture("/logout")
else
    res = ngx.location.capture("/login")
end
ngx.print(res.body)