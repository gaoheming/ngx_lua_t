local mysql     = require "models.mnetdetect"
local cjson     = require "cjson"
local errtype   = require "conf.errcode" .type
local mutil     = require "models.util"

local ngx_print = ngx.print
local ngx_log   = ngx.log
local ngx_ERR   = ngx.ERR
local req_args  = ngx.req.get_uri_args

local tonumber  = tonumber
local type      = type

local function _get_args()
    local args  = req_args()

    local start_time = tonumber(args["start_time"])
    local end_time = tonumber(args["end_time"])
    local page = tonumber(args["page"]) or 1
    local pagesize = tonumber(args["pagesize"]) or 20

    if start_time == nil or start_time <= 0
        or end_time == nil or end_time <= 0 then

        return nil, mutil.errinfo("INVALID_PARAM")
    end

    if page < 1 or pagesize < 0 then 
        return nil, mutil.errinfo("INVALID_PARAM")
    end 

    return {
        start_time = start_time,
        end_time = end_time,
        page = page,
        pagesize = pagesize,
    }
end

local function all()
    local args, code, err = _get_args()
    if not args then
        return nil, code, err
    end

    local low_num = (args["page"] - 1) * args["pagesize"]
    local num = args["pagesize"]

    local db = mysql.new()
    local res, err = db:search_by_time(args["start_time"], args["end_time"], low_num, num)
    if not res then
        return nil, errtype.DATABASE_ERR.errno, err
    end

    return res
end

local function _run()
    local ret
    local res, code, err = all()
    if not res then
        ret = {
            status = 0,
            errcode = code,
            info = {},
        }
    else
        ret = {
            status = 1,
            errcode = 0,
            info = res
        }
    end
    ngx_print(cjson.encode(ret))
end 

_run()
