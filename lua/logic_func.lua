module("logic_func", package.seeall)

function get_string()
    return "strings"
end

-- to prevent use of casual module global variables
getmetatable(lua.logic_func).__newindex = function (table, key, val)
    error('attempt to write to undeclared variable "' .. key .. '": '
            .. debug.traceback())
end
