local cjson = require('cjson')
local utils = require('utils')
local session = require("resty.session").open()
local files = utils.get_files('upload')
local data = {
    logged = session.data.logged or false,
    images = files
}
local json = cjson.encode(data)
ngx.say(json)
