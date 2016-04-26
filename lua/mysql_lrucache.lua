--不能直接像shared 那样用,需要外面包一层 xx.lua,然后xx.lua提供操作接口
local redis = require "resty.redis_iresty"
local mysql = require "mysql_caijia"
local cjson = require "cjson"
local lrucache = require "resty.lrucache"
local db = mysql:new()
local red = redis:new()
local print = ngx.say

cc = require "myapp" -- /data1/myapp.lua
local a = cc.go()
print(cc.go())

