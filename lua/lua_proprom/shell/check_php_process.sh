#!/bin/sh

#�ж�grep analyse_log_dir.php�Ľ�������
process_ccount=`ps -ef|grep while.php |grep -v grep | wc -l`;
#echo $process_ccount;

#�жϽ������Ƿ�С��1��,-lt��ʾС��
if [ "$process_ccount" -lt 1 ];then
        #����php����,����ѭ��redis���е�����
        /data1/webroot/res.mobile.kugou.com/php/while.php
fi;