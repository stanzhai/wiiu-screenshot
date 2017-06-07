local cjson = require('cjson')
local utils = require('utils')
local session = require("resty.session").open()
local logged = session.data.logged or false

function handle_get_or_post()
    local files = utils.get_files('upload')
    local data = {
        logged = session.data.logged or false,
        images = files
    }
    local json = cjson.encode(data)
    ngx.print(json)
end

function handle_delete()
    if not logged then
        ngx.print('permission deny')
        return
    end
    ngx.req.read_body()
    local args, err = ngx.req.get_post_args()
    local file = args.image
    os.remove('./upload/' .. file)
    os.remove('./thumbnail/' .. file)

    -- delete from qiniu
    require("utils").delete_file_from_qiniu(file)
    ngx.print("ok")
end

local method = ngx.req.get_method()
if method == "GET" or method == "POST" then
    handle_get_or_post()
elseif method == "DELETE" then
    handle_delete()
end

