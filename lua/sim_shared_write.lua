
local cache = ngx.shared['yueku']

local suc, err, forc = cache:set('sim4', '123t12est')
local aa =cache:get('sim4')

ngx.say(aa)
