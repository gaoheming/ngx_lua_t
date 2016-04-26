local _M = {}
local redis = require "resty.redis_iresty"
local mysql = require "mysql_caijia"
local cjson = require "cjson"
	local lrucache = require "resty.lrucache"
	local db = mysql:new()
local red = redis:new()
	local print = ngx.say
	local lrucache = require "resty.lrucache"

local c = lrucache.new(200)

function _M.go()
	local cachekey = 'key1'
	c:delete(cachekey)

	local body, err = c:get(cachekey)
	if not body then
	    body = db:query("select Host from user limit 3")
		c:set(cachekey,body,99)
	end
	return body
end

	return _M


