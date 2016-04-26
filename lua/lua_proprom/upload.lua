--ngx.say("hello world!!!!");
local command = require('command');
local redis = require('resty.redis');
--redis队列(list)key值
local LIST_KEY = 'write_key';


--写错误日志函数
local ERROR_LUA_FILE_PATH = '/data1/webroot/res.mobile.kugou.com/logs/lua_error.log';
local ERROR_REDIS_FILE_PATH = '/data1/webroot/res.mobile.kugou.com/logs/redis_error.log';
function write_log(path,str)
        local f,err = io.open(path,'a+');
        if not f then
                ngx.say("don't open error log file!");
                return;
        end
        f:write(str);
        f:close();
end

--写txt文件函数
local UPLOAD_PATH = '/data1/webroot/res.mobile.kugou.com/uploadpath';
--站点下载路径
local DOWNLOAD_PATH = 'uploadpath';
--文件后缀名
local FIX_TXT = '.txt';
--分隔符
local SEPARATOR = '/';
function write_txt(path,str)
        local f,err = io.open(path,'a+');
        if not f then
                ngx.say("don't open content txt file!");
                return;
        end
        f:write(str);
        f:write("\n--------------------------------------------------------------------------------------------------\n");
        f:close();
end


local args, err = ngx.req.get_uri_args();
--获取压缩数据内容
ngx.req.read_body();
local body = ngx.req.get_body_data();
if not body then
  local str = "["..os.date("%Y-%m-%d %H:%M:%S").."]无法获取到压缩数据!\n";
  write_log(ERROR_LUA_FILE_PATH,str);
  return;
end
--前4个字节不需要，前4个字节是压缩后的长度,所以不需要
body = string.sub(body,5);
--加密前字符串字节长度
local csize = tonumber(args['csize']);
if csize <= 0 then
   local thissize = #body;
   csize = thissize*5;
end
--解压缩数据
local content = command.uncompress(body,csize);

--return;
if not args then
  --ngx.say("aaaaa");
  local str = "["..os.date("%Y-%m-%d %H:%M:%S").."]无法获取到get内容!\n";
  write_log(ERROR_LUA_FILE_PATH,str);
  return;
end

--获取年月日时分秒
local log_date = os.date("%Y-%m-%d %H:%M:%S");
local txt_date = os.date("%Y-%m-%d");
local path_date = os.date("%Y%m");
--平台id
local platid = args['platid'];
--用户唯一标识
local imei = args['imei'];
--版本号
local ver = args['ver'];
--校验
local MDKEY = 'KgResMobile-2014';
local key = args['key'];
local mdk = ngx.md5(imei..ver..MDKEY);
if(mdk ~= key) then 
   local str = "["..os.date("%Y-%m-%d %H:%M:%S").."]["..imei.."@@"..key.."@@"..mdk.."]数据校验失败，此数据不是正常发送!\n";
   write_log(ERROR_LUA_FILE_PATH,str);
   return;
end
--需要上传的用户信息
--local content = args['content'];
--write_log(ERROR_FILE_PATH,platid.."@@"..imei.."@@".."ver".."@@"..content);
--平台、imei、版本、content都不为空的情况下写入文件，否则写入错误日志
if platid ~= '' and imei ~= '' and ver ~= '' and content ~= '' then
   --把路径写到redis里作队列,实时循环队列入库
   local red = redis:new();
   --1sec
   --red:set_timeout(1000);
   local ok,err = red:connect("127.0.0.1", 6379);
   if not ok then
      local error_str = "["..log_date.."]redis无法连接,请检查进程是否异常退出!\n";
      write_log(ERROR_REDIS_FILE_PATH,error_str);
      return;
   end
   --写txt文件的全路径,如:/data1/webroot/res.mobile.kugou.com/uploadpath/txt_date+platid+imei+ver.txt
   local w_dir = UPLOAD_PATH..SEPARATOR..path_date..SEPARATOR..txt_date..'@'..imei..FIX_TXT;
   --ngx.say(w_dir);
   write_txt(w_dir,content); 
   local downpath = DOWNLOAD_PATH..SEPARATOR..path_date..SEPARATOR..txt_date..'@'..imei..FIX_TXT;
   
   local lkey = downpath..'|'..platid..'|'..imei..'|'..ver..'|'..txt_date;
   red:rpush(LIST_KEY,lkey);
   ngx.say('Request Success!');
else
   local error_str = "["..log_date.."]"..platid.."@@"..imei.."@@"..ver.."+内容中,某个参数为空\n";
   write_log(ERROR_LUA_FILE_PATH,error_str);
end
