local cjson = require "cjson"
local print = ngx.print
t={}
cjson.encode_empty_table_as_object(true)
local str_json = cjson.encode(t)
print(str_json)
