local msecure   = require "models.secure"
local transfer  = require "models.filetransfer"
local mutil	= require "models.util"
local cjson     = require "cjson"
local config    = require "conf.config"


local ngx_time  = ngx.time
local ngx_print = ngx.print
local os_date   = os.date
local os_exec   = os.execute
local io_open   = io.open
local str_sub   = string.sub

local req_args  = ngx.req.get_uri_args

local tostring  = tostring
local tonumber  = tonumber
local type	= type

local function _get_args()
    local args  = req_args()
    if type(args["apikey"]) ~= "string" or args["apikey"] == ""
        or type(args["mid"]) ~= "string" or args["mid"] == ""
        or type(args["ver"]) ~= "string" or args["ver"] == ""
        or #args["sign"] ~= 32 then
        return nil, 1201,  "valid params"
    end

    local apikey    = args["apikey"]
    local signkey = config.signkey[apikey]
    if signkey == nil or signkey == '' then
        return nil, 1202, "not found apikey"
    end

    local sign = args["sign"]
    args["sign"] = nil
    local md5, str = msecure.set_token(signkey, args)
    if md5 ~= sign then
        return nil, 1203, "sign value not match"
    end

    return { mid = args["mid"], ver = args["ver"] }
end


local function _run()
    local args, code, err = _get_args()
    if not args then
        return args, code, err
    end
    local res = transfer.get_form_data()
    local file = res["file"]
    if file.size == nil or file.size == 0 then
        return nil, 1204, "not found data"
    end
    local extname = str_sub(file.filename, -3)
    local pictype = "mobile_cloud_pictures"
    local filename, err = transfer.upload(pictype, file.body, extname)
    if not filename then
    	ngx_log(ERR, err)
        return nil, 1210, err
    end
    mutil.log(filename, config.upload_server.log_path, pictype, "%Y%m%d")
    local furl = config.upload_server.dl_url .. "/" .. pictype .. "/" .. filename
    return furl
end


local ret
local url, code, err = _run()
if not url then
    ret = {
        status = 0,
        errcode = code,
        errmsg = err
    }
else
    ret = {
        status = 1,
        url = url
    }
end
ngx_print(cjson.encode(ret))
