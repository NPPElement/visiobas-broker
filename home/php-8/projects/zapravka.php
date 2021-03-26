<pre>
<?php

require_once __DIR__."/zap_func.php";

function DO_CREATE_ZAKAZ() {
    global $za_config;
    $vols = [20,50,80,120];
    $vol = $vols[array_rand($vols)];
    $types = ["DT", "95", "98"];
    print_r($za_config["kolonka"]);
    $col_idx = array_rand($za_config["kolonka"]);
    echo $col_idx."\n";
    return;

    $type = $types[array_rand($types)];
    echo "[$type] -> $vol";
    setState("zapravka");
    setStateParam("type", $type);
    setStateParam("volume", $vol);
    sleep(1);
}

function DO_ZAPRAVKA() {
    $volume = getStateParam("volume");
    $ready = 0;

    while ($ready<$volume) {
        $ready+=5;
        $bak = 0; // getValue();
    }
}




DO_CREATE_ZAKAZ();