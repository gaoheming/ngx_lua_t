local ngx_time  = ngx.time

local _M = {}


function _M.add(db, mid, mtype, path)
    local sql = "insert into t_files(mid, type, path, addtime) values(\'" .. mid .. "\', " .. mtype .. ", \'" .. path .. "\', " .. ngx_time() .. ")"
    local res, err, errno, sqlstate = db:query(sql)
    if not res then
        return nil, err
    end
    return true
end

return _M
