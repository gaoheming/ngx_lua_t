local upload = require "resty.upload"

local match = string.match

local ngx_log = ngx.log
local ERR   = ngx.ERR


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


function _M.save(data, filepath)
    local f = io.open(filepath, "w")
    if not f then
        return nil, "not open file"
    end
    local ok, err = f:write(data)
    f:close()
    return true
end

return _M
