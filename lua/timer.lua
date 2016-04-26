
local delay = 5

local handler 

handler = function (premature, param)
    if premature then
        return 
    end

    ngx.log(ngx.ERR, "param is " .. param)

    ngx.timer.at(delay, handler, "hello again")
end

local ok, err = ngx.timer.at(delay, handler, "hello hippo master")

-- if ok then
-- else
-- end