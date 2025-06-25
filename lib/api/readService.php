<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';

$query = "SELECT id_service, nama, harga FROM services ORDER BY id_service ASC";
$hasil = mysqli_query($connect, $query);
$temp = [];

while ($row = mysqli_fetch_array($hasil)) {
    $temp[] = array(
        'id_service' => $row['id_service'],
        'nama' => $row['nama'],
        'harga' => $row['harga']
    );
}

echo json_encode($temp);
