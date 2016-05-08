local regex = [[\d+]]

local m = ngx.re.match("hello, 1234", regex, "o")
if m then
	ngx.say(m[0])
else
	ngx.say("not matched!")
end


local s = "hello world"
local i, j = string.find(s, "hello")
print(i, j) --> 1 5


local s = "hello world from Lua"
for w in string.gmatch(s, "%a+") do
    print(w)
	end


--replace
local a = "Lua is cute"
local b = string.gsub(a, "cute", "great")


