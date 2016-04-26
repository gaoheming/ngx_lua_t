

function a( ... )
    -- body
    return b()
end

function b( ... )
    -- body
    return 'hellop'
end

ngx.say(a())