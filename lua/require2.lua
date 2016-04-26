local config    = require "conf.config"

local ngx_time  = ngx.time
local ngx_print = ngx.print
local os_date   = os.date
local os_exec   = os.execute
local io_open   = io.open
local str_sub   = string.sub
local randomseed= math.randomseed
local random    = math.random


ngx.print(config.db.host)
