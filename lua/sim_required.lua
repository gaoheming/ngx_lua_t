-- local logic = require "logic_func"

local tab = require "table_logic"

local function format_table(t)
    local str = ''
    for k,_ in pairs(t) do
        str = str .. k .. '\r\n'
    end
    return str
end

-- ngx.say(format_table(package.loaded))
-- ngx.say(format_table(_G))
ngx.say(format_table(tab))
-- ngx.say(tab.print_module())