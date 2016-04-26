
local mid = ngx.req.get_uri_args().mid

local af_test = ngx.shared['ngx_af_test']

af_test:set(mid, ngx.time())



ngx.say('hello')