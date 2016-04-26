local match = string.match

local ERR       = ngx.ERR
local ngx_log   = ngx.log
local ngx_time  = ngx.time
	local ngx_md5   = ngx.md5
	local servertime = ngx_time()
	local function http_post(url, stream, extname)
local servertime = ngx_time()
	local url = config.upload_server.url .. "?serverid=" .. config.upload_server.serverid
	.. "&servertime=" .. ngx_time()
	.. "&key=" .. ngx_md5(config.upload_server.serverid .. config.upload_server.serverkey .. servertime)
	.. "&type=" .. pictype
	.. "&extend_name=" .. extname
local httpc = http.new()
	local res, err = httpc:request_uri(url, {
			method  = "POST",
			body    = stream,
			headers = {
			["Content-Type"] = "application/x-www-form-urlencoded",
			}
			})
if not res then
return nil, err
end
if res.status ~= ngx.HTTP_OK then
return nil, "image service status is " .. res.status
	end
	end

