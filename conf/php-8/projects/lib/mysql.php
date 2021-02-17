<?php

global $sql_log;
$sql_log = [];


global $db_link;
//if(!$db_link=mysqli_connect("localhost", "root", "77877", "vbas", "3307")) die("!connect");
if(!$db_link=mysqli_connect("visiodesk.net", "maxuser", "maxpwd", "vbas", "4006")) die("!connect");
global $ENUMS;
$ENUMS = [
    "Object_Types"=>['analog-input','analog-output','analog-value','binary-input','binary-output','binary-value','calendar','command','device','event-enrollment','file','group','loop','multi-state-input','multi-state-output','notification-class','program','schedule','averaging','multi-state-value','trend-log','life-safety-point','life-safety-zone','accumulator','pulse-converter','event-log','global-group','trend-log-multiple','load-control','structured-view','access-door','access-credential','access-point','access-rights','access-user','access-zone','credential-data-input','network-security','bitstring-value','characterstring-value','date-pattern-value','date-value','datetime-pattern-value','datetime-value','integer-value','large-analog-value','octetstring-value','positive-integer-value','time-pattern-value','time-value','notification-forwarder','alert-enrollment','channel','lighting-output','folder','site','trunk','graphic']
];

query("SET NAMES 'utf8'");
query("SET CHARACTER SET utf8");
query("SET CHARACTER_SET_CONNECTION=utf8");

global $timeSql;
$timeSql = 0;

function query($sql) {
    global $timeSql;
    global $sql_log;
    global $db_link;
    $sql_log[]=$sql.";";
    $t1 = microtime(true);
    $r =  mysqli_query($db_link, $sql);
    $timeSql+=microtime(true)-$t1;
    if(mysqli_errno($db_link)) {
//        echo $sql."\n";
        echo  mysqli_error($db_link)."\n";
    }
    return $r;
}


function select($sql) {
    $result = array();
    $r = query($sql);
    if($r) {
        while ($row=mysqli_fetch_assoc($r)) {
            if(isset($row["id"])) $result[$row["id"]] = $row;
            else $result[] = $row;
        }
        mysqli_free_result($r);
    }

    return $result;
}


function getRecord($sql) {
    $r = select($sql);
//    print_r($r);
    return count($r)>0 ? reset($r) : false;
}