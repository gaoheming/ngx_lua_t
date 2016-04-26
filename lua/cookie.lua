local ck = require "resty.cookie"
local cookie, err = ck:new()
--curl localhost/api/cookie --cookie "Name=abc;aa=1"
local field, err = cookie:get("Name")
ngx.say(field)

local ok, err = cookie:set({
		key = "Name", value = "Bob", path = "/",
		domain = "example.com", secure = true, httponly = true,
		expires = "Wed, 09 Jun 2021 10:18:14 GMT", max_age = 50,
		extension = "a4334aebaec"
})
