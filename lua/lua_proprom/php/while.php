#!/usr/local/php/bin/php
<?php
/*
*循环获取redis队列(list)，把数据插入到mysql数据库中
*/
date_default_timezone_set('Asia/Shanghai');
define('LIST_KEY','write_key');
define('PHP_SLEEP_LOG','/data1/webroot/res.mobile.kugou.com/logs/php_sleep.log');
define('PHP_INSERT_ERROR_LOG','/data1/webroot/res.mobile.kugou.com/logs/php_insert_error.log');
define('DOMAN','http://res.mobile.kugou.com/');
$fields = 'platid,ver,imei,file_path,upload_time,upload_date,addtime';
$arr_fields = explode(',',$fields);
//require_once('./mysql.pdo.php');
//$mysql = new pdoMysql('10.1.1.173','tongjiuser','^>PuwHME','detect_user_network_status',true);
require_once(dirname(__FILE__).'/mysql.class.php');
$mysql = new Mysql('10.1.1.173','tongjiuser','^>PuwHME','detect_user_network_status',false);
//print_r($mysql);
$redis = new redis();
//print_r($redis);
$redis->connect('127.0.0.1', 6379);
//var_dump($red); //结果：bool(true) 
//$list_len = $redis->lsize(LIST_KEY); 
//echo $list_len."\n";die;
//$content = $red->lgetrange(LIST_KEY,0,-1);
//print_r($content);
while(true){
        $len_count = 200;
        $list_len = $redis->llen(LIST_KEY);
        if($list_len <= 0){
                $str = '['.date('Y-m-d H:i:s')."]哥,redis队列已经空了,先休息5秒钟后再继续吧!\n";
                file_put_contents(PHP_SLEEP_LOG,$str,FILE_APPEND);
                sleep(5);
                continue;
        }
        //如果队列长度小于等于$len_count,那么就全部取出，避免最后的数据没有被入库
        if($list_len <= $len_count){
                $len_count = $list_len;
        }
        $insert_sql = "INSERT INTO content(".$fields.") ";
        $content = $redis->lgetrange(LIST_KEY,0,$len_count);
        $arr_imei = array();
        $i = 1;
        foreach($content as $v){
                $str_arr = explode('|',$v);
                $path = addslashes(DOMAN.$str_arr[0]);//文件路径
                $platid = addslashes($str_arr[1]);//平台
                $imei = addslashes($str_arr[2]);//imei
                $ver = addslashes($str_arr[3]);//版本
                $upload_time = $str_arr[4];//用户上传数据时间
                $upload_date = date('Y-m-d H:i:s',time());
                $where_time = date('Y-m',strtotime($upload_time));
                //判断单次取出来的全部数据是否有重复，避免相同的内容入库
                if(array_key_exists($imei,$arr_imei)){
                        continue;
                }
                $sql = "SELECT id FROM content WHERE upload_time='".strtotime($where_time)."' and imei='".$imei."' LIMIT 1";
                $result = $mysql->GetOne($sql);
                if(count($result) <= 0){
                        //主要用于记录单次取出的数据是否有重复内容
                        $arr_imei[$imei] = 1;
                        $val_str = "'".$platid."','".$ver."','".$imei."','".$path."','".strtotime($where_time)."','".$upload_date."','".date('Y-m-d H:i:s')."'";
                        if($i == 1){
                           $insert_sql .= "VALUES(".$val_str.")";
                        }else{
                           $insert_sql .= ",(".$val_str.")";
                        }
                        $i++;
                }
        }
        if($i >1){
                try{
                        $mysql->ExeSql($insert_sql);
                }catch(Exception $e){
                        $str =  '['.date('Y-m-d H:i:s')."]".$e->getMessage()."\n";
                        file_put_contents(PHP_INSERT_ERROR_LOG,$str,FILE_APPEND);
                }
        }
        //删除掉上面取出来的数据,保留后面的数据
        $redis->ltrim(LIST_KEY,$len_count,-1);
}