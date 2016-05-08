local json = require("cjson")

function json_decode( str )
	    local json_value = nil
		    pcall(function (str) json_value = json.decode(str) end, str)
	    return json_value
end

--[[
	--使用
local json = require("cjson.safe")
local str  = [[ {"key:"value"} ]]

local t    = json.decode(str)
	if t then
	    ngx.say(" --> ", type(t))
		end
	]]

--https://moonbingbing.gitbooks.io/openresty-best-practices/content/json/array_or_object.html
