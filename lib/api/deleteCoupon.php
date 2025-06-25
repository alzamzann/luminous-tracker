<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';

// Terima id_coupon dari request
$id_coupon = $_POST['id_coupon'];

// Query delete
$query = "DELETE FROM coupons WHERE id_coupon = '$id_coupon'";

if(mysqli_query($connect, $query)) {
    echo json_encode([
        "success" => true,
        "message" => "Kupon berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal menghapus kupon: " . mysqli_error($connect)
    ]);
}