<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: *");
header("Access-Control-Allow-Methods: *");

include 'config.php';

$nama = $_POST['data_nama'];
$paket = $_POST['data_paket'];
$orderDate = $_POST['data_orderDate'];
$status = $_POST['data_status'];
$deadline = $_POST['data_deadline'];

$sql = "INSERT INTO orders (nama, paket, orderDate, status, deadline) VALUES ('$nama', '$paket', '$orderDate', '$status', '$deadline')";

$connect->query($sql);