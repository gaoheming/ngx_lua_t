
local mysql     = require "resty.mysql"

local setmetatable  = setmetatable
local type          = type
local pairs         = pairs
local os_date       = os.date
local ngx_log       = ngx.log
local ngx_ERR       = ngx.ERR
local ngx_localtime = ngx.localtime

local io_open       = io.open

-- constants
local config = require "conf.config".network_detect.db
local netconf = require "conf.config".network_detect

local _M =  {}
local mt = { __index = _M }


local function read_file(filepath)
    local f = io_open(filepath, "r")
    if not f then
        return nil, "not open file"
    end
    local data, err = f:read()
    if not data then
        f:close()
        return nil, "read err"
    end
    f:close()

    return data
end

local function get_data(res)

    if type(res) == "table" then
        for _, info in pairs(res) do
            local path = info["path"]

            info["path"] = nil
            --info["data"] = read_file(path)
            info['url'] = netconf.download_url .. path
        end
    end

    return res
end

local function connect()
    local conn = mysql:new()

    conn:set_timeout(config.timeout)

    local ok, err, errno, sqlstate = conn:connect({
        host = config.host,
        port = config.port,
        database = config.database,
        user = config.user,
        password = config.password,
        max_packet_size = config.max_packet_size
    })

    if not ok then
        ngx_log(ngx_ERR, "failed to connect: ", err, ": ", errno, " ", sqlstate)
        return
    end

    return conn
end

local function keepalive(conn)
    if not config.idle_timeout or not config.max_keepalive then
        ngx_log(ngx_ERR, "not set idle_timeout and max_keepalive in config; turn to close")
        return
    end

    local ok, err = conn:set_keepalive(config.idle_timeout, config.max_keepalive)
    if not ok then
        ngx_log(ngx_ERR, "failed to set mysql keepalive: ", err)
    end
end

function _M.new(self)
    local db = connect()
    if db then
        return setmetatable({ db = db }, mt)
    end
end

function _M.add(self, args, path)
    local db    = self.db

    local imei      = args["imei"]
    local userid    = args["userid"] or ""
    local platform_id = args["platform_id"]
    local ver       = args["ver"]

    local sql = "insert into t_files(imei, userid, platform_id, ver, time, path) values(\'" .. imei .. "\', \'" .. userid .. "\', \'" .. platform_id .. "\', " .. ver .. ", \'" .. ngx_localtime() .. "\', \'" .. path .. "\')"

    return self:query(sql)
end

function _M.search(self, sql, low_num, num)
    local search_sql = "select imei, userid, platform_id, ver, time, path from t_files where " .. sql .. "limit " .. low_num .. ", " .. num
    local res = self:query(search_sql)
    res = get_data(res)

    return res
end

function _M.search_by_time(self, start_time, end_time, low_num, num)
    local st_time = os_date("%Y-%m-%d %H:%M:%S", start_time)
    local ed_time = os_date("%Y-%m-%d %H:%M:%S", end_time)

    local sql = "select imei, userid, platform_id, ver, time, path from t_files where time > \'" .. st_time .. "\' and time < \'" .. ed_time .. "\' limit " .. low_num .. ", " .. num

    local res = self:query(sql)
    res = get_data(res)

    return res
end

function _M.query(self, sql)
    local db = self.db
    local res, err, errno, sqlstate = db:query(sql)
    if not res then
        self:close()
        return nil, err
    end

    self:close()
    return res
end

function _M.close(self)
    local db = self.db
    return keepalive(db)
end

return _M
