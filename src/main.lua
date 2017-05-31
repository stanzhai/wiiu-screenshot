local ua = ngx.var.http_user_agent

function get_filename(res)  
    local filename = ngx.re.match(res[2], '(.+)filename="(.+)"(.*)')  
    if filename then   
        return filename[2]  
    end  
end  

-- index page handler
local handle_get = function ()
    local res = nil
    if string.find(ua, "(Nintendo WiiU)") then
        res = ngx.location.capture('/upload')
    else
        res = ngx.location.capture('/upload')
    end
    ngx.say(res.body)
end

local handle_post = function ()
    -- if string.find(ua, "(Nintendo WiiU)") == nil then
    --     ngx.say("Only Nintendo WiiU Browser is supported!")
    --     return
    -- end
    local upload = require("resty.upload")
    local chunk_size = 4096
    local form, err = upload:new(chunk_size)
    if not form then
        ngx.log(ngx.ERR, "failed to new upload: ", err)
        ngx.exit(500)
    end

    while true do
        local typ, res, err = form:read()

        if not typ then
             ngx.say("failed to read: ", err)
             return
        end

        if typ == "header" then
            local file_name = get_filename(res)
            ngx.log(ngx.ERR, file_name)
            if file_name then
                file_name = "./upload/" .. file_name
                file = io.open(file_name, "w+")
                if not file then
                    ngx.say("failed to open file ", file_name)
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

    ngx.redirect("/")
end


ngx.header['Server'] = 'wiiu-screenshot-server code by stan'
local method = ngx.req.get_method()
if method == "GET" then
    handle_get()
else
    handle_post()
end



