local msecure   = require "models.secure"
local mdb       = require "models.db"
local tfiles    = require "models.files"
local cjson     = require "cjson"
local config    = require "conf.config"

local ngx_time  = ngx.time
local ngx_print = ngx.print
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


local function _gen_file_name(ext)
    randomseed(ngx_time())
    return os_date("%Y%m%d%H%M%S",ngx_time()) .. random(100000, 999999) .. "." .. ext
end

local function _get_body_data()
    ngx_req_read_body()
    local body_data = ngx_req_get_body_data()
    if body_data == '' or body_data == nil then
        local datafile = ngx_req_get_body_file()
        if not datafile then
            return ''
        end
        local fh, err = io.open(datafile, "r")
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
    local mtype = tonumber(args["type"])
    if type(args["apikey"]) ~= "string" or type(args["apikey"]) == ""
        or type(args["mid"]) ~= "string" or type(args["mid"]) == ""
        or mtype == nil or mtype < 1
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
        ngx.log(ngx.ERR, md5 .. "\t" .. sign .. "\t" .. str)
        return nil, 1203, "sign value not match"
    end

    local body_data = ''
    if mtype == 1 then
        body_data = _get_body_data()
        if body_data == '' or body_data == nil then
            return nil, 1204, "body empty"
        end
    end

    return {
        mid         = args["mid"],
        ver         = args["ver"] and tostring(args["ver"]) or "",
        machine     = args["machine"] and tostring(args["machine"]) or "",
        mtype       = mtype,
        body_data   = body_data }
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


local function _upload_elogs(body_data)
    if body_data == '' or body_data == nil then
        return nil, 1204, "not found data"
    end
    local new_file_name = _gen_file_name("log")
    local dir = str_sub(new_file_name, 1, 6)
    local base_path = config.upload_path.elogs
    local ok, err = os_exec("mkdir -p " .. base_path .. "/" .. dir)
    if not ok then
        return nil, 1211, err
    end

    local path = "/"..dir.. "/".. new_file_name
    local ok, err = _save_file(body_data, base_path .. path)
    if not ok then
        return nil, 1211, err
    end
    return path
end


local function _run()
    local args, code, err = _get_args()
    if not args then
        return args, code, err
    end

    local path, code, err
    if args["mtype"] == 1 then
        path, code, err = _upload_elogs(args["body_data"])
    else
        path, code, err = nil, 1205, "type error"
    end
    if not path then
        return path, code, err
    end

    local db = mdb.getdb()
    local ok, err = tfiles.add(db, args["mid"], args["mtype"], args["ver"], args["machine"], path)
    if not ok then
        db:close()
        return nil, 1298, err
    end
    db:close()
    return true
end

local ret
local ok, code, err = _run()
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

