local ua = ngx.var.http_user_agent

function make_filename(res)  
    local match = ngx.re.match(res[2], '(.+)filename="(.+)"(.*)')
    if match then
        -- WiiU_screenshot_TV_01C93.jpg
        local filename = match[2]
        local split = require("./utils").split
        local data = split(filename, '_')
        data = split(data[#data], '.')
        local id = data[1]
        return id .. "_" .. os.date("%Y%m%d_%H%M%S") .. ".jpg"
    end
end

-- index page handler
local handle_get = function ()
    local res = nil
    if string.find(ua, "(Nintendo WiiU)") then
        local session = require "resty.session".open()
        if session.data.logged then
            res = ngx.location.capture('/wiiu')
        else
            res = ngx.location.capture('/admin')
        end
    else
        res = ngx.location.capture('/home')
    end
    ngx.say(res.body)
end

local handle_post = function ()
    if string.find(ua, "(Nintendo WiiU)") == nil then
        ngx.say("Only Nintendo WiiU Browser is supported!")
        return
    end

    local session = require "resty.session".open()
    if not session.data.logged then
        ngx.say("Permission deny!")
        return
    end

    local upload = require("resty.upload")
    local chunk_size = 4096
    local form, err = upload:new(chunk_size)
    if not form then
        ngx.log(ngx.ERR, "failed to new upload: ", err)
        ngx.exit(500)
    end

    local upload_file = nil
    local file = nil
    while true do
        local typ, res, err = form:read()

        if not typ then
             ngx.say("failed to read: ", err)
             return
        end

        if typ == "header" then
            local file_name = make_filename(res)
            if file_name then
                upload_file = file_name
                local full_file = "./upload/" .. file_name
                file = io.open(full_file, "w+")
                if not file then
                    ngx.say("failed to open file ", full_file)
                    return
                end
            end
         elseif typ == "body" then
            if file then
                file:write(res)
            end
        elseif typ == "part_end" then
            file:close()
            file = nil
        elseif typ == "eof" then
            break
        end
    end

    if upload_file then
        local cmd = 'convert -resize 128x128 "./upload/' .. upload_file .. '" "./thumbnail/' .. upload_file .. '"'
        os.execute(cmd)
        local upload_file_to_qiniu = require("utils").upload_file_to_qiniu
        upload_file_to_qiniu(upload_file)
    end

    ngx.redirect("/")
end

ngx.header['Server'] = 'wiiu-screenshot-server code by stan'
local method = ngx.req.get_method()
if method == "GET" then
    handle_get()
else
    handle_post()
end
