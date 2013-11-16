<?php
// Analyse sans sections
$ini_array = parse_ini_file("Test3.ini");
print_r($ini_array);

// Analyse avec sections
$ini_array2 = parse_ini_file("Test3.ini", true);
print_r($ini_array2);
?>