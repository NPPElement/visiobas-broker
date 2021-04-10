<?php

include  __DIR__."/MQTTClient.php";

global $mymqttClient;
$mymqttClient = new MQTTClient("visiodesk.net", 1883);
$mymqttClient->setAuthentication("user", "user");
$ok = $mymqttClient->sendConnect("phpclient".rand(100,999));
if(!$ok) die("Нет соединения с брокером");

function publishMqttValue($reference, $devId, $objId, $objType, $value, $status=0) {
//    echo "publishMqttValue($reference, $devId, $objId, $objType, $value, $status)\n";
//    return;
    global $mymqttClient;
    $reference = str_replace(":", "/", $reference);
    $reference = str_replace(".", "/", $reference);
    $mymqttClient->sendPublish($reference, "$devId $objId $objType $value $status", 0, 1);
}


