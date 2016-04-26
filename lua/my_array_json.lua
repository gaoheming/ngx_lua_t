local cjson = require "cjson"
local print = ngx.print
local t = {1, 2}
t[1000] = 99
cjson.encode_sparse_array(true)
local str_json = cjson.encode(t)
print(str_json)
