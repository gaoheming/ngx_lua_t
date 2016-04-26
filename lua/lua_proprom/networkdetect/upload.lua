local msecure   = require "models.secure"
local mdb       = require "models.db"
local tfiles    = require "models.files"
local mutil     = require "models.util"
local mysql     = require "models.mnetdetect"
local cjson     = require "cjson"
local config    = require "conf.config"
local mconf     = config.network_detect 
local errtype   = require "conf.errcode" .type

local ngx_time  = ngx.time
local ngx_print = ngx.print
local ngx_log   = ngx.log
local ngx_ERR   = ngx.ERR
local os_date   = os.date
local os_exec   = os.execute
local io_open   = io.open
local str_sub   = string.sub
local randomseed= math.randomseed
local random    = math.random

local req_args              = ngx.req.get_uri_args
local ngx_req_read_body     = ngx.req.read_body
local ngx_req_get_body_data = ngx.req.get_body_data
local ngx_req_get_body_file = ngx.req.get_body_file

local tostring      = tostring
local tonumber      = tonumber
local type          = type


local function _gen_file_name(ext)
    randomseed(ngx_time())
    return os_date("%Y%m%d%H%M%S",ngx_time()) .. random(100000, 999999) .. "." .. ext
end

local function _get_body_data()
    ngx_req_read_body()
    local body_data = ngx_req_get_body_data()
    if body_data == nil or body_data == '' then
        local datafile = ngx_req_get_body_file()
        if not datafile then
            return ''
        end
        local fh, err = io_open(datafile, "r")
        if not fh then
            return ''
        end
        fh:seek("set")
        body_data = fh:read("*a")
        fh:close()
    end
    return body_data
end


local function _get_args()
    local args  = req_args()

    local apikey = args["apikey"]
    local _t     = args["_t"]
    local imei = args["imei"]
    local userid = args["userid"]
    local platform_id = args["platform_id"]
    local ver = tonumber(args["ver"])

    --userid 可能为空
    if type(apikey) ~= "string" or apikey == ""
        or type(_t) ~= "string" or _t == ""
        or type(imei) ~= "string" or imei == ""
        or type(userid) == "boolean"
        or type(platform_id) ~= "string" or platform_id == ""
        or ver == nil then

        return nil, mutil.errinfo("INVALID_PARAM")
    end

    local signkey = config.signkey[apikey]
    if signkey == nil or signkey == '' then
        return nil, mutil.errinfo("INVALID_KEY")
    end

    local body_data = _get_body_data()
    if body_data == nil or body_data == '' then
        return nil, mutil.errinfo("EMPTY_DATA")
    end

    local sign = args["sign"]
    args["sign"] = nil

    local check_args = {
        imei        = imei,
        userid      = userid,
        platform_id = platform_id,
        ver         = tostring(ver),
        apikey      = apikey,
        _t          = _t,
    }

    local md5, str = msecure.set_token(signkey, check_args)
    if md5 ~= sign then
        ngx_log(ngx_ERR, md5 .. "\t" .. str)
        return nil, mutil.errinfo("SIGNATURE")
    end

    return {
        imei        = imei,
        userid      = userid,
        platform_id = platform_id,
        ver         = ver,
        body_data   = body_data
    }
end

local function _save_file(data, filepath)
    local f = io_open(filepath, "w")
    if not f then
        return nil, "not open file"
    end
    local ok, err = f:write(data)
    if not ok then
        f:close()
        return nil, "write err"
    end
    f:close()
    return true
end


local function _upload_data(body_data)
    if body_data == nil or body_data == '' then
        return nil, mutil.errinfo("EMPTY_DATA")
    end
    local new_file_name = _gen_file_name("log")
    local dir = str_sub(new_file_name, 1, 6)
    local second_dir = str_sub(new_file_name, 7, 8)
    local basepath = mconf.upload_path.log .. "/" .. dir .. "/" .. second_dir
    local ok, err = os_exec("mkdir -p " .. basepath)
    if not ok then
        return nil, errtype.SAVE_FILE_ERR.errno, err
    end

    local path = dir .. "/" .. second_dir .. "/" ..  new_file_name
    local ok, err = _save_file(body_data, basepath .. "/" .. new_file_name)
    if not ok then
        return nil, errtype.SAVE_FILE_ERR.errno, err
    end
    return path
end


local function all()
    local args, code, err = _get_args()
    if not args then
        return nil, code, err
    end

    local path, code, err = _upload_data(args["body_data"])
    if not path then
        return nil, code, err
    end

    local db = mysql.new()
    local ok, err = db:add(args, path)
    if not ok then
        return nil, errtype.DATABASE_ERR.errno, err
    end

    return true
end

local function _run()
    local ret
    local ok, code, err = all()
    if not ok then
        ret = {
            status = 0,
            errcode = code,
           -- errmsg = err
        }
    else
        ret = {
            status = 1,
            errcode = 0,
        }
    end
    ngx_print(cjson.encode(ret))
end 

_run()
