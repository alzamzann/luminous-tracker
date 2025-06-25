<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';

// Terima data dari form
$kode = $_POST['kode'];
$potongan = $_POST['potongan'];

// Query insert
$query = "INSERT INTO coupons (kode, potongan) VALUES ('$kode', '$potongan')";

if(mysqli_query($connect, $query)) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => mysqli_error($connect)]);
}
