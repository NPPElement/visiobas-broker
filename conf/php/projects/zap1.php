<?php

header("Content-Type: text/plain; charset=utf-8");


if(isset($_GET['ping'])) {

    exit("Ping...\n-----------");
}



require_once __DIR__."/zap_func.php";

define("F_ZSTATE", "z_state.json");
define("F_FUEL_SPEED", "z_fuel.json");
define("F_STOP", ".stop");
define("_DELAY_POMP", 2);
define("_DELAY_GUN_INACTIVCATE", 3);

$max_time = 58;
$start = time();

if(is_file(F_ZSTATE) && strlen($jc=file_get_contents(F_ZSTATE))>8) {
    $z = json_decode($jc, true);
} else {
    $z = [
        1 => [
            "zak" => 0,
            "speed" => 0,
            "ready" => 0,
            "type" => false,
            "time"=>0,
            "nextTo"=>0
        ],
        2 => [
            "zak" => 0,
            "speed" => 0,
            "ready" => 0,
            "type" => false,
            "time"=>0,
            "nextTo"=>0
        ],
        3 => [
            "zak" => 0,
            "speed" => 0,
            "ready" => 0,
            "type" => false,
            "time"=>0,
            "nextTo"=>0
        ],
    ];
}


if(isset($_GET['report'])) {
    print_r($z);
    exit("\n-----------");
}

if(isset($_GET['stop'])) {
    echo "STOP action";
    file_put_contents(F_STOP, date("r"));
    sleep(10);
    unlink(F_ZSTATE);
    exit("\n-----------");
}


if(isset($_GET['pause'])) {
    echo "PAUSE action";
    file_put_contents(F_STOP, date("r"));
    sleep(10);
    exit("\n-----------");
}

if(isset($_GET['start'])) {
    echo "START action";
    unlink(F_STOP);
    exit("\n-----------");
}

global $fuel_sp;
if(is_file(F_FUEL_SPEED) && strlen($jc=file_get_contents(F_FUEL_SPEED))>8) {
    $fuel_sp = json_decode($jc, true);
} else {
    $fuel_sp = [ 1=>[], 2=>[], 3=>[], ];
}



function calcFuelRashod($k) {
    global $fuel_sp;
    $rashod = 0;
    $now_ms = 1000*microtime(true);
    $from_time = $now_ms - 1000*60*60;
    $past_time =  $now_ms;
    foreach ($fuel_sp[$k] as $time=>$volume) {
        $time = 1.0*$time;
        if($time<$from_time) continue;
        if($past_time>$time) $past_time=$time;
        $rashod+=$volume;
    }

    $dT_ns = $now_ms-$past_time;
    if($dT_ns==0) return 0;
    $rashod_hour = $rashod / ( $dT_ns/(1000*60*60) );
    return $rashod_hour;
}


function serviceZak($k) {
    global $z;
    global $fuel_sp;
    $info = $z[$k];
    $dT = time()-$info['time'];
    if($dT==0) return;

    if($info['ready'] ==-1) {
        if(time()-$info['time']>=_DELAY_POMP) {
            setKolonkaVolume($k, 0);
            $z[$k]['ready'] = 0;
            $z[$k]['time'] = time();
        }
        return;
    }

    if($info['ready']<$info['zak']) {
        gunSetPomp($k, $info['type'], true);
        $vol1 = $info['speed'] * $dT;
        if($info['ready']+$vol1<=$info['zak']) {
            $z[$k]['ready'] = $info['ready']+$vol1;
            $z[$k]['time'] = time();
        } else {
            $vol1 = $info['zak']-$z[$k]['ready'];
            $z[$k]['ready'] = $info['zak'];
            $z[$k]['time'] = time();
        }
        $vol1 = round($vol1, 2);
        tankSub($info['type'], $vol1);
        $fuel_sp[$info['type']][microtime(true)*1000] = $vol1;
        setKolonkaVolume($k, $z[$k]['ready']);
    }

    if($z[$k]['ready']>=$z[$k]['zak']) {
        gunSetPomp($k, $info['type'], false);

        if($dT>=_DELAY_GUN_INACTIVCATE) {
            gunInActivate($k, $info['type']);
            $z[$k]['zak'] = 0;
        }
    }

}


function initZap($k) {
    global $z;
    $fuels = ["98","95","DT", "95"];

//    $fuels = ["DT"];
    shuffle($fuels);
    $type = false;
    foreach ($fuels as $f) {
        $vol = randFuelVolume($f==="DT");
        if(is_file($f.".tank") && (time()-filemtime($f.".tank")>60*5) ) unlink($f.".tank");
        if( !is_file($f.".tank") && isFuel($f, $vol)) {$type=normT($f); break; }
    }
    if(!$type) return false;

    $typeDT = normT("DT");
    $z[$k] = [
        "zak"=>$vol,
        "type"=>$type,
        "ready" => -1,
        "speed"=> $typeDT==$type ?  rand(40,100)/10 :  rand(20,50)/10, // litr/sec
        "time"=>time(),
        "nextTo"=>0
    ];
    gunActivate($k, $type);
    return true;
}



if(isset($_GET['reset'])) {
    file_put_contents(F_STOP, date("r"));
    sleep(20);
    zapravkaReset();
    unlink(F_ZSTATE);
    unlink(F_STOP);
    echo "Перезагрузка";
    setTimeStamp();

} else {

    while (time() - $start < $max_time && !is_file(F_STOP)) {
        $free = [];

        foreach ($z as $k => $info) {
//            if($k!=3) continue;
            if ($info["zak"]) serviceZak($k);
            else {
                if (!$info["nextTo"]) $z[$k]["nextTo"] = time() + rand(10, 50);
                else {
                    if ($info["nextTo"] < time()) initZap($k);
                }
            }

        }

        for($f=1;$f<=3;$f++) {
            setTankRashod($f, calcFuelRashod($f));
            $m = [1=>"98",2=>"95",3=>"DT"];
            $marka = $m[$f];

            if(is_file($marka.".tank")) {
                $from_time = 0+file_get_contents($marka.".tank");
                $tankVolume = getTankVolume($marka);
                if($from_time>time()) {
                    if($tankVolume<MAX_FUEL_LEVEL) {
                        $newVolume = $tankVolume + 100;
                        if ($newVolume >= MAX_FUEL_LEVEL) {
                            $newVolume = MAX_FUEL_LEVEL;
                            file_put_contents($marka . ".tank", time() + 20);
                        }
                        setTankVolume($marka, $newVolume);
                    } else {
                        unlink($marka . ".tank");
                    }
                }
            }


        }

        setTimeStamp();
        usleep(1000*500);

    }


    print_r($z);
}

file_put_contents(F_ZSTATE, json_encode($z));
file_put_contents(F_FUEL_SPEED, json_encode($fuel_sp));
echo "\n-----------------\n\n";
//print_r($sql_log);
echo "sql time: $timeSql\n";
echo join("\n", $sql_log);
