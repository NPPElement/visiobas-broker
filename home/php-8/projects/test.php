<pre>
<?php
set_time_limit(60*20);

echo "tets";
die();


include_once "lib/mysql.php";
include_once "lib/mymqtt.php";
define("FILE_ZERO", "zero.json");

$data_types = [
    'analog-input',
//    'analog-output',
    'analog-value',
//    'binary-input',
//    'binary-output',
//    'binary-value',
//    'multi-state-input',
//    'multi-state-output',
//    'multi-state-value'
];


//$objects = select("select id, device_id, Object_Identifier, Object_Type, -1+Object_Type as typeId, `value`, status, Object_Name from objects where Object_Name like '%AI_27506%' and Object_Type in ('".join("','",$data_types)."') limit 0,5000");
//$objects = select("select id, device_id, Object_Identifier, Object_Type, -1+Object_Type as typeId, `value`, status, Object_Name from objects where Object_Type in ('".join("','",$data_types)."') limit 0,5000");
$objects = select("select id, device_id, Object_Identifier, Object_Type, -1+Object_Type as typeId, `value`, status, Object_Name from objects where Object_Name LIKE '%2240%' AND Object_Type in ('".join("','",$data_types)."') limit 0,50");

//echo count($objects)."\n\n";

print_r($objects);
die();

$VAL0 = is_file(FILE_ZERO) ? json_decode(file_get_contents(FILE_ZERO), true) : [];

foreach ($objects as $o) if(!isset($VAL0[$o['id']])) $VAL0[$o['id']] = $o['value'];

file_put_contents(FILE_ZERO, json_encode($VAL0));

//die();
$sig = [];

$t1 = time();
while (time()-$t1<15) {
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

//    $value0 = $sig[$id]['value0'];
    $value0 = 0+$VAL0[$id];
    $valueCurrent = $sig[$id]['value'];


    $newValue = false;
    if( strpos($sig[$id]['Object_Type'], "analog")!==false ) {
        $newValue =  rand($value0*8,$value0*12)/10 + rand(0,$value0/10);
    } else if( strpos($sig[$id]['Object_Type'], "multi")!==false ) {

    } else  {
        $newValue = ((rand(0,1000) + microtime(true)))&255>220 ? 1 :0 ;
        if($valueCurrent==0) continue;
        $newValue = 0;
    }
    if($newValue===false) continue;


    $sig['id']['value'] = $newValue;

    $newStatus = rand(0,100)>85 ? 2: 0;
    $newStatus = 0;
//    echo $newValue."\n";
//    continue;
    publishMqttValue($reference, $devId, $objId, $typeId, $newValue, $newStatus);
    usleep(1000*10);

}
