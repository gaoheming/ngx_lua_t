module("dbutil", package.seeall)
local mysql_pool = require("mysql_pool")

function query(sql)

    local ret, res, _ = mysql_pool:query(sql)
    if not ret then
        ngx.log(ngx.ERR, "query db error. res: " .. (res or "nil"))
        return nil
    end

    return res
end

function execute(sql)

    local ret, res, sqlstate = mysql_pool:query(sql)
    if not ret then
        ngx.log(ngx.ERR, "mysql.execute_failed. res: " .. (res or 'nil') .. ",sql_state: " .. (sqlstate or 'nil'))
        return -1
    end

    return res.affected_rows
end

local cjson = require "cjson"
local a = query('select * from mysql.user')

ngx.say(cjson.encode(a))