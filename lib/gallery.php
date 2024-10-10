<?php
// gallery.php
header("Content-Type: application/json");

// Database connection details
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "praktikum";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

// Fetch gallery data
$sql = "SELECT kd_galery, judul_galery, isi_galery, tgl_post_galery FROM galery WHERE status_galery = 1 ORDER BY tgl_post_galery DESC";
$result = $conn->query($sql);

$gallery = array();

if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $gallery[] = $row;
    }
}

echo json_encode($gallery);

$conn->close();
?>