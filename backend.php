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

$requestMethod = $_SERVER['REQUEST_METHOD'];
$requestUri = explode('/', trim($_SERVER['REQUEST_URI'], '/'));

// API routing
switch ($requestMethod) {
    case 'GET':
        getEntries($conn);
        break;
    case 'POST':
        addEntry($conn);
        break;
    case 'PUT':
            updateEntry($conn); // Pass the ID to the update function
        break;
    case 'DELETE':
            deleteEntry($conn);
    
        break;
    default:
        http_response_code(405);
        echo json_encode(["message" => "Method Not Allowed"]);
        break;
}

// Function to get all entries
function getEntries($conn) {
    $sql = "SELECT * FROM entries";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $entries = [];
        while ($row = $result->fetch_assoc()) {
            $entries[] = $row;
        }
        echo json_encode($entries);
    } else {
        echo json_encode([]);
    }
}

// Function to add a new entry
function addEntry($conn) {
    $data = json_decode(file_get_contents("php://input"), true);
    
    // Check if the 'text' field is provided
    if (!isset($data['text']) || empty(trim($data['text']))) {
        http_response_code(400); // Bad Request
        echo json_encode(["message" => "Text field is required"]);
        return;
    }

    $text = $data['text'];
    $image = null; // Set to NULL if you don't have an image field

    $stmt = $conn->prepare("INSERT INTO entries (text, image) VALUES (?, ?)");
    $stmt->bind_param("ss", $text, $image);

    if ($stmt->execute()) {
        http_response_code(201); // Return 201 Created
        echo json_encode(["id" => $stmt->insert_id, "text" => $text, "image" => $image]);
    } else {
        http_response_code(500); // Internal Server Error
        echo json_encode(["message" => "Error inserting entry: " . $stmt->error]);
    }

    $stmt->close();
}

// Updated function to edit an entry
function updateEntry($conn) {
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

// Function to delete an entry
function deleteEntry($conn) {
    // Get the ID from the URL
    $id = basename($_SERVER['REQUEST_URI']);
    
    // Prepare the DELETE statement
    $stmt = $conn->prepare("DELETE FROM entries WHERE id = ?");
    $stmt->bind_param("i", $id);
    
    if ($stmt->execute()) {
        http_response_code(200);
        echo json_encode(["message" => "Entry deleted successfully"]);
    } else {
        http_response_code(500);
        echo json_encode(["message" => "Error deleting entry"]);
    }

    $stmt->close();
}

// Close the database connection
$conn->close();
?>
 