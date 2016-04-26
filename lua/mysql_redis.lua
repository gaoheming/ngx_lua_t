local redis = require "resty.redis_iresty"
local mysql = require "mysql_caijia" --/data1
local cjson = require "cjson"
local db = mysql:new()
local red = redis:new()
local print = ngx.print

local cachekey = 'key1'

local body, err = red:get(cachekey)
--print(body)
if not body then
	body = db:query("select Host from user limit 3")
	red:set(cachekey,body)
--	print(body)
--else
--	print(body)
end


print(body)

--cjson.encode(aa)
