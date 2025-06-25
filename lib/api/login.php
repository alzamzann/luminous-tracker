<?php
header("Content-Type: application/json");
header('Access-Control-Allow-Origin:*');
header('Access-Control-Allow-Methods:GET,POST,PUT,DELETE');
header('Access-Control-Allow-Headers:Content-Type,Authorization');

include 'config.php';

$data = json_decode(file_get_contents("php://input"), true);

$username = $data['username'] ?? '';
$password = $data['password'] ?? '';

if (empty($username) || empty($password)) {
    echo json_encode(["status" => "error", "message" => "Username dan password harus diisi"]);
    exit();
}

$sql = "SELECT * FROM admin WHERE username = '$username'";
$result = mysqli_query($connect, $sql);

if (mysqli_num_rows($result) > 0) {
    $user = mysqli_fetch_assoc($result);
    if ($password === $user['password']) {
        echo json_encode([
            "status" => "success", 
            "message" => "Login berhasil"
        ]);
    } else {
        echo json_encode([
            "status" => "error", 
            "message" => "Password salah"
        ]);
    }
} else {
    echo json_encode([
        "status" => "error", 
        "message" => "Username tidak ditemukan"
    ]);
}

mysqli_close($connect);
?>
