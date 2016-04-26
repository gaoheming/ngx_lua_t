local shared = ngx.shared['ngx_cache']

local suc, err, f

for index = 1, 10000, 1 do
    shared:set(tostring(index), index)
end


for index = 10000, 1, -1 do
    shared:get(tostring(index))
end