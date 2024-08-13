<?php
// Set headers for the API
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, GET, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Handle preflight requests
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit;
}

// Database configuration
$host = 'localhost';    
$user = 'root';         
$password = '';         
$database = 'diary_app';

// Create a connection
$conn = new mysqli($host, $user, $password, $database);

// Check the connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Handle PUT request for editing an entry
if ($_SERVER['REQUEST_METHOD'] === 'PUT') {
    updateEntry($conn);
    exit;
}

// Close the database connection
$conn->close();

function updateEntry($conn) {
    // Get the ID from the URL
    $id = basename($_SERVER['REQUEST_URI']);
    
    // Get the input data
    $data = json_decode(file_get_contents("php://input"), true);
    $text = $data['text'];
    
    // Update the entry in the database
    $stmt = $conn->prepare("UPDATE entries SET text = ? WHERE id = ?");
    $stmt->bind_param("si", $text, $id);
    
    if ($stmt->execute()) {
        echo json_encode(["message" => "Entry updated successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Error updating entry"]);
    }

    $stmt->close();
}
?>
