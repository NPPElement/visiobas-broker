<?php



global $db_link;
//if(!$db_link=mysqli_connect("localhost", "root", "77877", "vbas", "3307")) die("!connect");
//if(!$db_link=mysqli_connect("172.16.16.60", "maxuser", "maxpwd", "vbas", "4006")) die("!connect");
if(!$db_link=mysqli_connect("maxscale", "maxuser", "maxpwd", "vbas", "4006")) die("!connect");
global $ENUMS;
$ENUMS = [
    "Object_Types"=>['analog-input','analog-output','analog-value','binary-input','binary-output','binary-value','calendar','command','device','event-enrollment','file','group','loop','multi-state-input','multi-state-output','notification-class','program','schedule','averaging','multi-state-value','trend-log','life-safety-point','life-safety-zone','accumulator','pulse-converter','event-log','global-group','trend-log-multiple','load-control','structured-view','access-door','access-credential','access-point','access-rights','access-user','access-zone','credential-data-input','network-security','bitstring-value','characterstring-value','date-pattern-value','date-value','datetime-pattern-value','datetime-value','integer-value','large-analog-value','octetstring-value','positive-integer-value','time-pattern-value','time-value','notification-forwarder','alert-enrollment','channel','lighting-output','folder','site','trunk','graphic']
];

query("SET NAMES 'utf8'");
query("SET CHARACTER SET utf8");
query("SET CHARACTER_SET_CONNECTION=utf8");



function query($sql) {
    global $db_link;
    echo $sql."\n";
    $r =  mysqli_query($db_link, $sql);
    if(mysqli_errno($db_link)) {
        echo $sql."\n";
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
