local shared = ngx.shared['ngx_cache']


local suc, err, forc

for index = 1, 10000, 1 do
    suc, err, forc = shared:set(tostring(index), string.rep('a', 1))
end


suc, err, forc = shared:set('foo', string.rep('a', 1000))

ngx.say(err)