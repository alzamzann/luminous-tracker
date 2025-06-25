<?php
header('Access-Control-Allow-Origin: *'); // Izinkan semua domain
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');

include 'config.php';

$id = $_POST['data_id_order'];

$connect->query("DELETE FROM orders WHERE id_order = '" . $id . "'");