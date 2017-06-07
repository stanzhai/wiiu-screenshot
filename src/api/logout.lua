local session = require("resty.session").start()
session:destroy()
ngx.redirect("/")
