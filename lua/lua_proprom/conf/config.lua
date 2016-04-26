local _M = {
    signkey = {
        and01 = "gP>Mr38JN4&#",
        ios01 = "ApR2o!(Ld*zC",
    },
    upload_path = {
        elogs   = "/data1/webroot/res.mobile.kugou.com/files/elogs"
    },
    db  =   {
        host        = "10.1.1.157",
        port        = 3306,
        database    = "d_elogs",
        user        = "elogs_user",
        password    = "AB4^>PuwHMEb33",
        max_packet_size = 1024 * 1024
    },
    upload_server = {
        url         = "http://image.upload.kgidc.cn/v2/stream_upload",
        dl_url      = "http://imge.kugou.com/v2",
        serverid    = 1117,
        serverkey   = 'fkq323SpNm61HvqDZL10F9Rfg2d8IFh4',
        log_path    = "/data1/webroot/res.mobile.kugou.com/logs"
    }
}

_M.network_detect = {
    db  =   {
        host        = "10.1.1.177",
        port        = 3306,
        database    = "db_net_detect",
        user        = "root",
        password    = "kgsql@)!)tmp",
        max_packet_size = 1024 * 1024,

        timeout         = 3000,
        max_keepalive   = 60,   -- keepalive num for each woker
        idle_timeout    = 30,
    },
    upload_path = {
        log   = "/data1/webroot/res.mobile.kugou.com/files"
    },
    download_url = 'http://res.mobile.kugou.com/static/networkdetect/',

}

return _M
