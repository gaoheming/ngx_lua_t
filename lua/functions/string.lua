

local utf8 = require "system.helper.utf8"

local find = string.find
local sub = string.sub
local insert = table.insert
local concat = table.concat
local type = type
local re_gsub = ngx.re.gsub
local random = math.random
local time = ngx.time
local gsub = string.gsub
local gmatch = string.gmatch
local unescape_uri = ngx.unescape_uri

local ok, uuid = pcall(require, "resty.uuid")
if not ok then
    uuid = {}
    uuid.generate = function () return time() .. random(1000, 9999) end
end

-- " " (ASCII 32 (0x20)), an ordinary space.
-- "\x0B" (ASCII 11 (0x0B)), a vertical tab.
local charlist = "[\t\n\r\32\11]+"


local _M = { _VERSION = '0.01' }


-- @param pattern The split pattern (I.e. "%s+" to split text by one or more
-- whitespace characters).
function _M.split(s, pattern, ret)
    if not pattern then pattern = "%s+" end
    if not ret then ret = {} end
    local pos = 1
    local fstart, fend = find(s, pattern, pos)
    while fstart do
        insert(ret, sub(s, pos, fstart - 1))
        pos = fend + 1
        fstart, fend = find(s, pattern, pos)
    end
    if pos <= #s then
        insert(ret, sub(s, pos))
    end
    return ret
end

-- @param pattern The pattern to strip from the left-most and right-most of the
function _M.strip(s, pattern)
    local p = pattern or "%s*"
    local sub_start, sub_end

    -- Find start point
    local _, f_end = find(s, "^"..p)
    if f_end then sub_start = f_end + 1 end

    -- Find end point
    local f_start = find(s, p.."$")
    if f_start then sub_end = f_start - 1 end

    return sub(s, sub_start or 1, sub_end or #s)
end

-- to do: not sure allowable_tags work perfect
function _M.strip_tags(s, allowable_tags)
    local pattern = "</?[^>]+>"
    if allowable_tags and type(allowable_tags) == "table" then
        pattern = "</?+(?!" .. concat(allowable_tags, "|") .. ")([^>]*?)/?>"
    end
    return re_gsub(s, pattern, "", "iux")
end

-- Translate certain characters
-- from can be the table { from = to, from1 = to1 }
-- s is the utf8 string
function _M.strtr(s, from, to)
    local ret = {}
    if type(from) ~= "table" then
        from = { [from] = to }
    end
    for c in utf8.iter(s) do
        if from[c] then
            insert(ret, from[c])
        else
            insert(ret, c)
        end
    end
    return concat(ret)
end


function _M.uniqid()
    local id = uuid.generate()
    local pref = re_gsub(id, "-[^-]+$", "")
    local short = re_gsub(pref, "-", "")
    return short
end


function _M.rawurldecode(str)
    return unescape_uri(gsub(str, "+", "%%2B"))
end


function _M.trim(str)
    local pref = re_gsub(str, "^" .. charlist, "") or str
    return re_gsub(pref, charlist .. "$", "") or pref
end


function _M.str_replace(search, replace, str)
    if type(search) == "string" then
        return gsub(str, search, replace)
    end

    local rp_type = type(replace) == "string" and true or nil

    for i = 1, #search do
        str = gsub(str, search[i], rp_type and replace or replace[i])
    end
    return str
end

--table.concat
function _M.explode(separator, str)
    local str = str .. separator

    local ret, i = {}, 1
    for s in gmatch(str, "(.-)" .. separator) do
        ret[i] = s
        i = i + 1
    end

    return ret
end


return _M

