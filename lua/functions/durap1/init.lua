

require "resty.core"

--get_instance()
get_instance = function ()
    return ngx.ctx.dp
end
