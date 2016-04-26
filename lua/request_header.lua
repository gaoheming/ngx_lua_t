local function parse_array(key, tab)
    local str = ''

    for _, v in pairs(tab) do
        str = str .. key .. '  ' .. v .. '\r\n'
    end

    return str
end

local function print_table(t)


    local str = ''
    for k,v in pairs(t) do
        if type(v) == "table" then
            str = str .. parse_array(k, v)
        else
            str = str .. k .. '  ' .. (v) .. '\r\n'
        end
        
    end
    return str
end

ngx.req.set_header('Foo', {'Bar1', 'Bar2'})

ngx.req.set_header('Foo1', 'Bar2')

ngx.req.set_header('user-agent', {})

local res = ngx.location.capture('/api/sub_request_header.json')

if res.status == ngx.HTTP_OK then
    ngx.say(res.body)
else
    ngx.exit(res.status)
end
