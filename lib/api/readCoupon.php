<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';

$query = "SELECT * FROM coupons ORDER BY id_coupon DESC";
$hasil = mysqli_query($connect, $query);
$temp = [];

while ($row = mysqli_fetch_array($hasil)) {
    $temp[] = array(
        'id_coupon' => $row['id_coupon'],
        'kode' => $row['kode'],
        'potongan' => $row['potongan']
    );
}

echo json_encode($temp);
