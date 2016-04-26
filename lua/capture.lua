
ngx.req.read_body()
local data = ngx.req.get_body_data()

local res = ngx.location.capture('/api/sub_capture.json?a=test', { args = { b = 3, c = ':' }} )

ngx.say(res.body)
-- ngx.say(data)