local json = require "cjson"

local function format_table(t)
    local str = ''
    for k,v in pairs(t) do
        str = str .. k .. '--' .. v .. '\r\n'
    end
    return str
end

-- 将json转换成lua table

local str_json = '{"key":"this is key", "value":"this is value", "num":1}'

local t = json.decode(str_json)

ngx.say(format_table(t))

-- 将lua table 转成成 json string

-- local t = {key='table key', value="table value", num=1}

-- local str_json = json.encode(t)

-- ngx.say(str_json)

-- 将lua table 转成json 数组

-- local t = {key={'list1', 'list2', 'list..'}, num = 1}

-- local str_json = json.encode(t)

-- ngx.say(str_json)

-- local t = {} 

-- json.encode_empty_table_as_object(true)

-- local str_json = json.encode(t)

-- ngx.say(str_json)


-- sparse array 

-- local t = {1, 2}

-- t[1000] = 99

-- json.encode_sparse_array(true)

-- local str_json = json.encode(t)

-- ngx.say(str_json)


-- erro capture

-- local str_error_json = [["key":"this is key", "value":"this is value"}]]

-- local function json_decode(str)
--     local json_value = nil
--     pcall (function (str) json_value = json.decode(str) end, str)
--     return json_value
-- end

-- local t = json_decode(str_error_json)


-- ngx.say(t)








