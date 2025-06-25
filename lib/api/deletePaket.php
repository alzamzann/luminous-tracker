<?php
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
header('Content-Type: application/json');

include 'config.php';

// Terima id_service dari request
$id_service = $_POST['id_service'];

// Query delete
$query = "DELETE FROM services WHERE id_service = '$id_service'";

if(mysqli_query($connect, $query)) {
    echo json_encode([
        "success" => true,
        "message" => "Paket berhasil dihapus"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Gagal menghapus paket: " . mysqli_error($connect)
    ]);
}

mysqli_close($connect);
