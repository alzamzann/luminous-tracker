<?php
// Tambahkan error reporting
// error_reporting(E_ALL);
// ini_set('display_errors', 1);

// Gunakan konstanta untuk konfigurasi database
define('DB_HOST', 'localhost');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'luminous_db');

$connect = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME);

// if ($connect->connect_error) {
//     die("Connection failed: " . $connect->connect_error);
// }