<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';
$query = "SELECT * FROM orders ORDER BY orders.id_order DESC";
$hasil = mysqli_query($connect, $query);
$temp = [];

while ($row = mysqli_fetch_array($hasil)) {
    $temp[] = $row;
}

echo json_encode($temp);
