<?php


/**
 * /electro.php?ns=1000&sec=60&percent=15
 * Запустить симуляцию на 60 секунд с паузами в 1000 микросекунд с вариабельностью 15% от исходной величины
 * Если параметр не указать - будет по умолчанию то, что написано в первой строке
 *
 */


header("Content-Type: text/plain; charset=utf-8");
define("FILE_ZERO", "zero_electro.json");
define("FILE_MARK", "electro.mark");

$delay_ns = isset($_GET['ns']) ? 0+$_GET['ns'] : 100000; // 10 обновлений в секунду (в наносекундах)
$time_sec = isset($_GET['sec']) ? 0+$_GET['sec'] : 57;
$delta_percent = isset($_GET['percent']) ? 0+$_GET['percent'] : 15;
if($delta_percent>70 || $delta_percent<1) $delta_percent = 15;
$VAL0 = is_file(FILE_ZERO) ? json_decode(file_get_contents(FILE_ZERO), true) : [];
set_time_limit($time_sec+5);

if(is_file(FILE_MARK) && (time()-filemtime(FILE_MARK)<$time_sec)) exit("please, wait ".($time_sec-time()+filemtime(FILE_MARK))." seconds");
file_put_contents(FILE_MARK, "Start at ".date("r"));

//exit();

include_once __DIR__."/lib/mysql.php";
include_once __DIR__."/lib/mymqtt.php";


$data_types = ['analog-input','analog-value',];
$objects = select("select id, device_id, Object_Identifier, Object_Type, -1+Object_Type as typeId, `value`, status, Object_Name from objects where Object_Name LIKE 'Site:Engineering/Electricity.%' AND Object_Name NOT LIKE 'Site:Engineering/Electricity.UMG_96RM%' AND Object_Type in ('".join("','",$data_types)."')");


foreach ($objects as $o) if(!isset($VAL0[$o['id']])) $VAL0[$o['id']] = $o['value'];
file_put_contents(FILE_ZERO, json_encode($VAL0));
$sig = [];

$t1 = time();
while (time()-$t1<$time_sec) {
    $obj =  $objects[array_rand($objects)];
    $id = $obj['id'];
    if(!isset($sig[$id])) {
        $sig[$id] = $obj;
        $sig[$id]['value0'] = $sig[$id]['value'];
        $sig[$id]['status0'] = $sig[$id]['status'];
    }
    $reference = $sig[$id]['Object_Name'];
    $devId = $sig[$id]['device_id'];
    $typeId = $sig[$id]['typeId'];
    $objId = $sig[$id]['Object_Identifier'];
    $value0 = 0+$VAL0[$id];
    $newValue =  rand($value0*85,$value0*115)/100 + rand(0,$value0/10);
    $sig['id']['value'] = $newValue;
    $newStatus = rand(0,100)>85 ? 2: 0;
    $newStatus = 0;
    publishMqttValue($reference, $devId, $objId, $typeId, $newValue, $newStatus);
    usleep($delay_ns);
}

unlink(FILE_MARK);
