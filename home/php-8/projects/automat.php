<pre>
<?php

global $SP;
define("ST_FILE", "state.json");
if(is_file(ST_FILE) && strlen($jc=file_get_contents(ST_FILE))>8) $SP = json_decode($jc, true);
else  $SP = ["state"=>"start"];

function wr($s) {
    echo $s."\n";
}

function getState() {
    global $SP;
    return $SP['state'];
}

function setStateParam($name, $value) {
    global $SP;
    if(!isset($SP[getState()])) $SP[getState()] = [];
    $SP[getState()][$name] = $value;
}

function getStateParam($name, $default = false) {
    global $SP;
    if(!isset($SP[getState()])) return $default;
    if(!isset($SP[getState()][$name])) return $default;
    return $SP[getState()][$name];
}

function setState($state) {
    global $SP;
    $SP['state'] = $state;
}


function DO_START() {
    usleep(20000);
    setState("circle");
    setStateParam("max", 5);
    setStateParam("current", 0);
    setStateParam("next_stage", "end");
}

function DO_CIRCLE() {
    $max = getStateParam("max");
    $current = getStateParam("current");
    if($current<$max) setStateParam("current", $current+1);
    else setState( getStateParam("next_stage") );
}

function DO_END() {
    wr("Конец выполнения");
    setState("reset");
}

function DO_RESET() {
    global $SP;
    $SP = ["state"=>"start"];
    wr("Очистка состояния");
}

$stage_func = "DO_".strtoupper(getState());
if(function_exists($stage_func)) {
    echo "Выполняем $stage_func\n";
    $stage_func();
} else die("Отсутствует функция");

print_r($SP);

file_put_contents(ST_FILE, json_encode($SP));


