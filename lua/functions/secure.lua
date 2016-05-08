local config    = require "conf.config"

local pairs = pairs
local ipairs = ipairs
local table_sort = table.sort
local str_upper = string.upper
local ngx_time  = ngx.time
local md5 = ngx.md5


local _M = {}


local function join_args(args)
    local keys, str = {}, ''
    for k, v in pairs(args) do
        keys[#keys + 1] = k
    end
    table_sort(keys)

    for _i, k in ipairs(keys) do
        if type(args[k]) == "table" then
            str = str .. k .. join_args(args[k])
        else
            str = str .. k .. args[k]
        end
    end

    return str
end


function _M.get_key(apikey)
     local conf = config.signkey[apikey]
     if conf == nil or conf["secretkey"] == nil then
         return ''
     end
     if conf["expire"] ~= nil and conf["expire"] < ngx_time() then
         return ''
     end
     return conf["secretkey"]
end

function _M.set_token(secretkey, args, payload)
    local str = join_args(args) .. secretkey

    if payload then
        str = str .. payload
    end

    return md5(str), str
end


return _M
