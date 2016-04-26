local errtype   = require "conf.errcode" .type

local ngx_time  = ngx.time
local str_format= string.format

local io_open   = io.open
local os_date   = os.date


local _M = {}


function _M.log(msg, fpath, typ, format)
    local typ     = typ or "err"
    local logfile = fpath .. "/" .. typ .. "_" .. os_date(format, ngx_time()) .. ".log"
    local f = io_open(logfile, "a")
    if not f then
        return false
    end
    local msginfo = str_format("[%s]%s", os_date("%Y-%m-%d %H:%M:%S", ngx_time()), msg)
    local ok, err = f:write(msginfo, "\r\n")
    f:close()
end

function _M.errinfo(key)
	if errtype[key] then
		return errtype[key].errno, errtype[key].msg  
	end 

	return nil, nil
end

return _M
