<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';

// Terima data dari form
$nama = $_POST['nama'];
$harga = $_POST['harga'];

// Query insert
$query = "INSERT INTO services (nama, harga) VALUES ('$nama', '$harga')";

if(mysqli_query($connect, $query)) {
    echo json_encode([
        "success" => true,
        "message" => "Paket berhasil ditambahkan"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal menambahkan paket: " . mysqli_error($connect)
    ]);
}
