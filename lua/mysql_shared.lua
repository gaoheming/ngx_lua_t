local redis = require "resty.redis_iresty"
local mysql = require "mysql_caijia"
local cjson = require "cjson"
local db = mysql:new()
local red = redis:new()
local print = ngx.print

local cachekey = 'sim4'

local cache = ngx.shared['yueku']
--local body =cache:delete(cachekey)
local body =cache:get(cachekey)
--print(body)
if not body then
	body = db:query("select Host from user limit 3")
	local suc, err, forc = cache:set(cachekey, body)
--	print(body)
--else
--	print(body)
end


print(body)


