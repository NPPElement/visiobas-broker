<?php

define("MAX_FUEL_LEVEL", 2500);

require_once __DIR__."/lib/mysql.php";

global $changedRef;
$changedRef = [];
global $za_config;
$za_config = [
    "bak"=>[
        "98"=>["volume"=>"Site:PETROL-STATIONS/PETROL-STATION_1.tank98_level", "rashod"=>"Site:PETROL-STATIONS/PETROL-STATION_1.sred_rashod_tank_1"],
        "95"=>["volume"=>"Site:PETROL-STATIONS/PETROL-STATION_1.tank95_level", "rashod"=>"Site:PETROL-STATIONS/PETROL-STATION_1.sred_rashod_tank_2"],
        "DT"=>["volume"=>"Site:PETROL-STATIONS/PETROL-STATION_1.tankDT_level", "rashod"=>"Site:PETROL-STATIONS/PETROL-STATION_1.sred_rashod_tank_3"],
    ],

    "kolonka"=>[
        [
            "volume"=>"Site:PETROL-STATIONS/PETROL-STATION_1.post_1_litres",
            "pistol"=>[
                "98"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_1_1_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_1_1_status"],
                "95"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_1_2_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_1_2_status"],
                "DT"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_1_3_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_1_3_status"],
            ]
        ],
        [
            "volume"=>"Site:PETROL-STATIONS/PETROL-STATION_1.post_2_litres",
            "pistol"=>[
                "98"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_2_1_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_2_1_status"],
                "95"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_2_2_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_2_2_status"],
                "DT"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_2_3_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_2_3_status"],
            ]
        ],
        [
            "volume"=>"Site:PETROL-STATIONS/PETROL-STATION_1.post_3_litres",
            "pistol"=>[
                "98"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_3_1_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_3_1_status"],
                "95"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_3_2_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_3_2_status"],
                "DT"=>["activated"=>"Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_3_3_activated","pomp"=>"Site:PETROL-STATIONS/PETROL-STATION_1.pump_3_3_status"],
            ]
        ],



    ]
];


function wr($s) {
    echo $s."\n";
}



function getValue($reference) {
    $r = getRecord("select * from objects where Object_Name='".$reference."'");
    $res =  is_array($r) ? $r['value'] : false;
//    wr("> $res\t$reference");
    return $res;
}


function setValue($reference, $value) {
    global $changedRef;
    $changedRef[]=$reference;
//    query("update objects set `value`=$value, `timestamp`=NOW() WHERE Object_Name='".$reference."'");
    query("update objects set `value`=$value WHERE Object_Name='".$reference."'");
//    wr("[$value] \t => $reference");
}


function randFuelVolume($maxi = false) {
    $vols = $maxi ? [20,50,80,120,200,300] :  [20,50,80,120];
    $vol = $vols[array_rand($vols)];
    return $vol;
}

function isFuel($marka, $volume=0) {
    $m = [1=>"98",2=>"95",3=>"DT"]; if(isset($m[$marka])) $marka = $m[$marka];

    $value = getTankVolume($marka);
    $existsFuel =  $value-$volume > 0.1*MAX_FUEL_LEVEL;

    if(!$existsFuel && !is_file($marka.".tank")) {
        file_put_contents( $marka.".tank", time() + rand(50,600));
    }

    if($existsFuel && is_file($marka.".tank") && (time()-filemtime($marka.".tank")>60*5) ) unlink($marka.".tank");

    return $existsFuel;
}

function getTankVolume($marka) {
    $m = [1=>"98",2=>"95",3=>"DT"]; if(isset($m[$marka])) $marka = $m[$marka];
    return getValue("Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level");
}

function setTankVolume($marka, $volume) {
    $m = [1=>"98",2=>"95",3=>"DT"]; if(isset($m[$marka])) $marka = $m[$marka];
    setValue("Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level", round($volume, 2));
}
function setTankRashod($marka_or_type, $rashod) {
    $type = normT($marka_or_type);
    setValue("Site:PETROL-STATIONS/PETROL-STATION_1.sred_rashod_tank_$type", $rashod);
}

function tankAdd($marka, $volume) {

    $m = [1=>"98",2=>"95",3=>"DT"]; if(isset($m[$marka])) $marka = $m[$marka];
    $sql = "update objects set `value`=`value`+$volume where Object_Name='Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level'";
    global $changedRef;
    $changedRef[]="Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level";

//    $sql = "update objects set `value`=`value`+$volume, `timestamp`=NOW() where Object_Name='Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level'";
    query($sql);
}

function tankSub($marka, $volume) {
    $m = [1=>"98",2=>"95",3=>"DT"]; if(isset($m[$marka])) $marka = $m[$marka];
    $sql = "update objects set `value`=`value`-$volume where Object_Name='Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level'";
    global $changedRef;
    $changedRef[]="Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level";

//    $sql = "update objects set `value`=`value`-$volume, `timestamp`=NOW() where Object_Name='Site:PETROL-STATIONS/PETROL-STATION_1.tank" . $marka . "_level'";
    query($sql);
}

function normT($marka_or_idx) {
    $tr = ["98"=>1,"95"=>2,"DT"=>3];
    if(isset($tr[$marka_or_idx])) $marka_or_idx = $tr[$marka_or_idx];
    return $marka_or_idx;
}

// kolonkaIdx - 1,2,3
// $marka_or_idx 98,95,DT or 1,2,3
function gunIsBusy($k, $marka_or_idx) {
    $marka_or_idx = normT($marka_or_idx);
    return getValue("Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_".(0+$k)."_".$marka_or_idx."_activated")!=0;
}

function kolonkaIsBusy($idx) {
    for($f = 1;$f<=3;$f++) if(gunIsBusy($idx, $f)) return true;
    return false;
}

function gunActivate($kol, $gun) {
    if(kolonkaIsBusy($kol)) return false;
    $gun = normT($gun);
    setValue("Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_".(0+$kol)."_".$gun."_activated", 1);
    for($g=1;$g<=3;$g++) if($g!=$gun) gunInActivate($kol, $g);
    return true;
}

function gunInActivate($kol, $gun) {
    $gun = normT($gun);
    setValue("Site:PETROL-STATIONS/PETROL-STATION_1.gas_gun_".(0+$kol)."_".$gun."_activated", 0);
    return true;
}

function gunSetPomp($kol, $gun, $value) {
    $gun = normT($gun);
    setValue("Site:PETROL-STATIONS/PETROL-STATION_1.pump_".(0+$kol)."_".$gun."_status", $value?1:0);
    if($value) for($g=1;$g<=3;$g++) if($g!=$gun) gunSetPomp($kol, $g, false);
    return true;
}

function gunGetPomp($kol, $gun) {
    $gun = normT($gun);
    return getValue("Site:PETROL-STATIONS/PETROL-STATION_1.pump_".(0+$kol)."_".$gun."_status") !=0;
}

function setKolonkaVolume($k, $value) {
    setValue("Site:PETROL-STATIONS/PETROL-STATION_1.post_".(0+$k)."_litres", $value);
}

function setTimeStamp() {
    global $changedRef;
    $changedRef = array_unique($changedRef);
    if(count($changedRef)==0) return;
    $sql = "update objects set `timestamp`=NOW() WHERE Object_Name IN ('".join("','", $changedRef)."')";
    query($sql);

}

function zapravkaReset() {
//    unlink(F_FUEL_SPEED);
    for($k=1;$k<=3;$k++) {
        setKolonkaVolume($k, 0);
        for($f=1;$f<=3;$f++) {
            gunInActivate($k, $f);
            gunSetPomp($k, $f, false);
        }
    }
    for($f=1;$f<=3;$f++) {
        setTankVolume($f, MAX_FUEL_LEVEL);
    }
}