
local _M = {}

_M.type = {
	SUCCESS  		= { errno = 0, msg = "上报成功" },
	INVALID_PARAM 	= { errno = 1201, msg = "必选参数为空或缺少参数" },
	INVALID_KEY 	= { errno = 1202, msg = "无效apikey" },
	SIGNATURE 		= { errno = 1203, msg = "sign签名错误" },
	EMPTY_DATA 		= { errno = 1204, msg = "上报数据为空" },
	DATA_TYPE_ERR 	= { errno = 1205, msg = "上报类型错误" },
	SAVE_FILE_ERR 	= { errno = 1211, msg = "保存文件错误" },
	DATABASE_ERR 	= { errno = 1298, msg = "数据库错误" },
	
}

return _M