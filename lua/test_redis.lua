local redis = require "resty.redis_iresty"
local red = redis:new()

local ok, err = red:set("dog", "an animal")
if not ok then
	ngx.say("failed to set dog: ", err)
return
end

--ngx.say("set result: ", ok)
local cachekey = 'dog'

--red:del(cachekey)
local body, err = red:get(cachekey)

if not body then
--  ngx.say("failed to get key1: ", err)
--  return
end

local res = body
--local res=ngx.null
if not res then
	ngx.say("not get")
else 
	ngx.say(res)
end




