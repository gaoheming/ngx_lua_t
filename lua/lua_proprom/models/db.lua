local mysql     = require "resty.mysql"
local config    = require "conf.config"

local _M = {}

function _M.getdb()
    local db, err = mysql:new()
    if not db then
        return nil, 1299, err
    end
    local ok, err, errno, sqlstate = db:connect(config.db)
    if not ok then
        return nil, 1299, err
    end

    return db
end

return _M
