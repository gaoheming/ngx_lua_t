
local _M = { _VERSION = '0.001' }

local mt = { __index = _M }

function _M.print_name(self)
    return "this function is in resty module"
end

return _M

