local upload    = require "resty.upload"
local http      = require "resty.http"
local config    = require "conf.config"

local match = string.match

local ERR       = ngx.ERR
local ngx_log   = ngx.log
local ngx_time  = ngx.time
local ngx_md5   = ngx.md5


local _M = {}

local function _get_form_data()
    local ret = {}
    local form, err = upload:new(4086)
    if not form then
        ngx_log(ERR, "failed to new upload: " .. err)
        return ret
    end
    form:set_timeout(1000)
    local key, filename, filetype, body, size = '', '', '', '', 0
    while true do
        local typ, res, err = form:read()
        if not typ then
            ngx_log(ERR, "failed to read upload from: " .. err)
            return ret
        end

        if typ == "header" then

            if res[1] == "Content-Disposition" then
                key = match(res[2], "name=\"(.-)\"")
                filename = match(res[2], "filename=\"(.-)\"")
            elseif res[1] == "Content-Type" then
                filetype = res[2]
            end

        elseif typ == "body" then

            body = body .. res
            size = size + #res

        elseif typ == "part_end" then
            local _tmp = {
                    filename    = filename,
                    filetype    = filetype,
                    body        = body,
                    size        = size
                }
            body    = ''
            size    = 0
            local kv = ret[key]
            if not kv then
                ret[key] = _tmp
            elseif type(kv) == "table" and #kv > 0 then
                ret[key][#kv+1] = _tmp
            else
                ret[key] = { ret[key], _tmp }
            end

        elseif typ == "eof" then

            break

        end
    end
    return ret
end

_M.get_form_data = _get_form_data


function _M.upload(pictype, stream, extname)
    local servertime = ngx_time()
    local url = config.upload_server.url .. "?serverid=" .. config.upload_server.serverid
                    .. "&servertime=" .. ngx_time()
                    .. "&key=" .. ngx_md5(config.upload_server.serverid .. config.upload_server.serverkey .. servertime)
                    .. "&type=" .. pictype
                    .. "&extend_name=" .. extname
    local httpc = http.new()
    local res, err = httpc:request_uri(url, {
        method  = "POST",
        body    = stream,
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
        }
    })
    if not res then
        return nil, err
    end
    if res.status ~= ngx.HTTP_OK then
        return nil, "image service status is " .. res.status
    end
    -- ngx_log(ERR, res.body)
    local res = cjson.decode(res.body)
    if res.status ~= 1 then
        return nil, "image service error code : " .. res.error_code
    end
    return res.data.filename
end

return _M
