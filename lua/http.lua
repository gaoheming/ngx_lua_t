
local req_args      = ngx.req.get_uri_args --

ngx.req.read_body()
local req_posts		=ngx.req.get_post_args()

local ngx_req_get_body_data = ngx.req.get_body_data
local ngx_req_get_body_file = ngx.req.get_body_file

--local config    = require "conf.config"
local http    = require "resty.http"
local redis = require "resty.redis"
local mysql = require "resty.mysql"
local memcache = require "resty.memcached"
local lock = require "resty.lock"
local random = require "resty.random"
local luastring = require "resty.string"
local str_lower = string.lower --upper
local ngx_md5   = ngx.md5
local ngx_time  = ngx.time
local print = ngx.print
local ngx_null 	= ngx.null
local tostring  = tostring
local tonumber  = tonumber
local type      = type
local str_gsub	= string.gsub

local ngx_log   = ngx.log
local ERR       = ngx.ERR

local ngx_time  = ngx.time()  
local ngx_print = ngx.print
local os_date   = os.date
local os_exec   = os.execute 
local io_open   = io.open
local str_sub   = string.sub
local randomseed= math.randomseed
local random    = math.random
local tostring      = tostring
local tonumber      = tonumber


local args = ngx.req.get_uri_args()
local args1 = ngx.req.get_uri_args()
local cjson = require "cjson"


--local str = table.concat({"a", "b", "c"}, ",")
--print(str)
--ngx.sleep(5)
local str='a,b,cd';
local example = "an ,example ,string"
local cc={}

--for i in string.gmatch(example, ",") do
--table.insert(cc,i)
--  end
--print (cjson.encode(cc))
local red = redis:new()
red:set_timeout(1000) -- 1 sec
local ok, err = red:connect("127.0.0.1", 6379)

local body, err = red:get("key1")


if not res then
	local httpc = http.new()
	httpc:set_timeout(12 * 1000)
	local res, err = httpc:request_uri("http://push.mobile.kugou.com/v1/report/device?_t=1405651220&apikey=ios01&sign=f359a3aa05699e4cd353c69b26d427d5") 
 	body=(res.body)
	ok, err = red:set("key1", body)
	if not ok then
		ngx.say("failed to set key1: ", err)
	return
	end
end

obj=cjson.decode(body)
--obj.a='test33'..'just'
print(obj.status)
