thisMonth=`date +%Y%m`;
#echo $thisMonth;
path='/data1/webroot/res.mobile.kugou.com/uploadpath/';
#echo $path;
myPath=$path$thisMonth;
#echo $myPath;

#����Ƿ���1��,��1�ž��ж�Ŀ¼�Ƿ����
runday=`date +%d`;
m_runday=`echo $runday | sed 's/^0*//'`;
#echo $m_runday;
if [ $m_runday -eq 1 ]; then
        if [ ! -d "$myPath" ]; then
                mkdir -m 777 $myPath;
        fi
fi