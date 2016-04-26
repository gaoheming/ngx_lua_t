
-- 172.16.255.236

local sock, err = ngx.socket.tcp()

if err then
    ngx.log(ngx.ERR, "create object failed")
else
    -- log
    for index = 1, 10, 1 do
        local ok, err = sock:connect('172.16.255.234', 8080)
        if not ok then
            ngx.log(ngx.ERR, err)
            return
        end
        sock:send('abcd')
        
        ok, err = sock:setkeepalive(0, 5) 
        if not ok then
            ngx.log(ngx.ERR, err)
        end
        ngx.sleep(1)

    end

end

