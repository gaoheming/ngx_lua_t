ngx.today
ngx.time
ngx.utctime
ngx.localtime
ngx.now
ngx.http_time
ngx.cookie_time


os.time
os.date('*t')


看起来像是计时精度的问题。ngx.now() 是有误差的，因为使用了nginx 自身的时间缓存。对于精度要求较高的计时，应使用下面的调用序列： 

    ngx.update_time() 
	    local now = ngx.now() 

	值得一提的是，ngx.now() 只有毫秒精度。 

	另外，确保你*没有*在 nginx.conf 里面配置 timer_resolution 指令，见 

	    http://nginx.org/en/docs/ngx_core_module.html#timer_resolution 


https://github.com/iresty/nginx-lua-module-zh-wiki#ngxtoday
 local request_time = ngx.now() - ngx.req.start_time()












