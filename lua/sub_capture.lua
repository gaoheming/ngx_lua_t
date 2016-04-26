

local function print_array(tab)
    local str = ''

    for _, v in pairs(tab) do
        str = str .. '  ' .. tostring(v) .. '\r\n'
    end

    return str
end


local args  = ngx.req.get_uri_args()

ngx.print(print_array(args))