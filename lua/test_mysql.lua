-- /data1/mysql_caijia.lua
local mysql = require "mysql_caijia"
local cjson = require "cjson"
local db = mysql:new()
local res = db:query("select Host from user limit 3")
--ngx.say(cjson.encode(j))
local aa ={}
if res then
	--ngx.print(res)
	res = cjson.decode(res)
	local i=1
	for k,v in ipairs(res) do
		ngx.say(v.Host)
		aa[i] = v.Host
		i = i+1
	end
end

ngx.say(cjson.encode(aa))

--if type(res) == "table" then
