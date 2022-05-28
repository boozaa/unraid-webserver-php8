<?php 
require_once('../vendor/autoload.php');

$f3     = Base::instance();
$f3->config('../config/config.ini');


$f3->route('GET /',
    function($f3, $args) {
        echo "Ok dans /";
    }
);

$f3->route('GET /compte',
    function($f3, $args) {
        echo "Ok dans /compte";
    }
);


$f3->run();