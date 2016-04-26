module("module", package.seeall)


function print_name()
    return "this function is in module.lua"
end

-- getmetatable(lua.logic_func).__newindex = function (table, key, val)
--     error()
-- end