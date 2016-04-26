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



local function _is_valid_page(page, pagesize)
    if page < 1 or pagesize < 0 then
        return false
    end

    return true
end 


local function _get_args()
    local args  = req_args()

    local imei = args["imei"]
    local userid = args["userid"]
    local platform_id = args["platform_id"]
    local page = tonumber(args["page"]) or 1
    local pagesize = tonumber(args["pagesize"]) or 20

    if type(imei) == "boolean" or imei == ""
        or type(userid) == "boolean" or userid == ""
        or type(platform_id) == "boolean" or platform_id == "" then

        return nil, mutil.errinfo("INVALID_PARAM")
    end

    if not _is_valid_page(page, pagesize) then 
        return nil, mutil.errinfo("INVALID_PARAM")
    end 

    return {
    	imei = imei,
    	userid = userid,
    	platform_id = platform_id,
    	page = page,
    	pagesize = pagesize,
	}
end

local function _get_query_sql(args)
	local res = ""

	if args["imei"] then
		res = res .. "imei = \'" .. args["imei"] .. "\' "
	end

	if args["userid"] then
        res = res == "" and res or res .. "and " 
		res = res .. "userid = \'" .. args["userid"] .. "\' "
	end

	if args["platform_id"] then
        res = res == "" and res or res .. "and " 
		res = res .. "platform_id = \'" .. args["platform_id"] .. "\' "
	end

	return res
end

local function all()
    local args, code, err = _get_args()
    if not args then
        return nil, code, err
    end

    local sql, code, err = _get_query_sql(args)
    if not sql then 
    	return nil, code, err
    end

    local low_num = (args["page"] - 1) * args["pagesize"]
    local num = args["pagesize"]

    local db = mysql.new()
    local res, err = db:search(sql, low_num, num)
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
            info = res,
        }
    end
    ngx_print(cjson.encode(ret))
end 

_run()
