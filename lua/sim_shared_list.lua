
local list = ngx.list['ngx_cache_list']


local suc, err = list:push('a')


if err ~= nil then
    ngx.log(ngx.ERR , err)
end
-- for index = 1, 10000, 1 do
--     list:push(index)
-- end


-- for index = 1, 10000, 1 do
--     list:pop()
-- end

-- shared:get('s')

-- local str = 'test string'

-- local suc, err = list:push(str)

-- local res = list:pop()


-- ngx.say(v)

-- ngx.say(type(package.loaded.ngx.list['ngx_cache_list'].pop))
-- -- ngx.say(getmetatable(package.loaded.ngx.shared['ngx_cache']))


