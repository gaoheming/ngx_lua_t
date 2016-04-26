thisMonth=`date +%Y%m`;
#echo $thisMonth;
path='/data1/webroot/res.mobile.kugou.com/uploadpath/';
#echo $path;
myPath=$path$thisMonth;
#echo $myPath;

#检查是否是1号,是1号就判断目录是否存在
runday=`date +%d`;
m_runday=`echo $runday | sed 's/^0*//'`;
#echo $m_runday;
if [ $m_runday -eq 1 ]; then
        if [ ! -d "$myPath" ]; then
                mkdir -m 777 $myPath;
        fi
fi