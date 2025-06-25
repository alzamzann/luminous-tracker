<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: *");
include 'config.php';

$id = $_POST['id_order'];
$nama = $_POST['data_nama'];
$paket = $_POST['data_paket'];
$orderDate = $_POST['data_orderDate'];
$deadline = $_POST['data_deadline'];
$status = $_POST['data_status'];

// Perbaiki query UPDATE - hapus id_order dari SET karena tidak perlu diupdate
$query = "UPDATE orders SET 
    nama = '$nama', 
    paket = '$paket', 
    orderDate = '$orderDate',
    deadline = '$deadline',
    status = '$status' 
    WHERE id_order = '$id'";

if($connect->query($query)) {
    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "error" => $connect->error]);
}