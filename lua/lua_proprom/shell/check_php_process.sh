#!/bin/sh

#判断grep analyse_log_dir.php的进程总数
process_ccount=`ps -ef|grep while.php |grep -v grep | wc -l`;
#echo $process_ccount;

#判断进程数是否小于1个,-lt表示小于
if [ "$process_ccount" -lt 1 ];then
        #开启php程序,用于循环redis队列的数据
        /data1/webroot/res.mobile.kugou.com/php/while.php
fi;