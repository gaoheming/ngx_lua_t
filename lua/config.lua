local _M = {
	REDIS_HOST = '127.0.0.1',
	REDIS_PORT = '6379',
	DBHOST = '127.0.0.1',
	DBPORT = '3306',
	DBUSER = 'root',
	DBPASSWORD = '123456',
	DBNAME = 'mysql',
	DEFAULT_CHARSET = 'utf8',
	signkey = {
		and01 = "gP>Mr38JN4&#",
		ios01 = "ApR2o!(Ld*zC",
	},
	upload_path = {
		elogs   = "/data1/webroot/res.m1.c1.com/files/elogs"
	},
	db  =   {
		host        = "127.0.0.1",
		port        = 3306,
		database    = "mysql",
		user        = "root",
		password    = "123456",
		max_packet_size = 1024 * 1024
	},
	upload_server = {
		url         = "http://image.upload.kgidc.cn/v2/stream_upload",
		dl_url      = "http://imge.c1.com/v2",
		serverid    = 1117,
		serverkey   = 'fkq323SpNm61HvqDZL10F9Rfg2d8IFh4',
		log_path    = "/data1/webroot/res.m1.c1.com/logs"
	}
}

_M.network_detect = {
	db  =   {
		host        = "127.0.0.1",
		port        = 3306,
		database    = "mysql",
		user        = "root",
		password    = "123456",
		max_packet_size = 1024 * 1024,

		timeout         = 3000,
		max_keepalive   = 60,   -- keepalive num for each woker
			idle_timeout    = 30,
	},
	upload_path = {
		log   = "/data1/webroot/res.m1.c1.com/files"
	},
	download_url = 'http://res.m1.c1.com/static/networkdetect/',

}

return _M

