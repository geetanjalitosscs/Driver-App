<?php
require_once './db_config.php';

setApiHeaders();

try {
    $pdo = getDatabaseConnection();
} catch(PDOException $e) {
    sendErrorResponse('Database connection failed: ' . $e->getMessage());
}

$data = json_decode(file_get_contents('php://input'), true);

$driverId = $data['driver_id'] ?? 0;
$currentPassword = $data['current_password'] ?? '';
$newPassword = $data['new_password'] ?? '';

if ($driverId <= 0) {
    sendErrorResponse('Invalid driver ID', 400);
}

if (empty($currentPassword) || empty($newPassword)) {
    sendErrorResponse('Current password and new password are required', 400);
}

// Check driver status before proceeding
checkDriverStatus($driverId);

if (strlen($newPassword) < 6) {
    sendErrorResponse('New password must be at least 6 characters long', 400);
}

try {
    // First, verify the current password
    $stmt = $pdo->prepare("SELECT password FROM drivers WHERE id = ?");
    $stmt->execute([$driverId]);
    $driver = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$driver) {
        sendErrorResponse('Driver not found', 404);
    }

    // Verify current password (handle both plain text and hashed passwords)
    $isValidPassword = false;
    
    // Check if password is hashed (starts with $2y$)
    if (strpos($driver['password'], '$2y$') === 0) {
        // Password is hashed, use password_verify
        $isValidPassword = password_verify($currentPassword, $driver['password']);
    } else {
        // Password is plain text, do direct comparison
        $isValidPassword = ($currentPassword === $driver['password']);
    }
    
    if (!$isValidPassword) {
        sendErrorResponse('Wrong password please check again', 401);
    }

    // Hash the new password
    $hashedNewPassword = password_hash($newPassword, PASSWORD_DEFAULT);

    // Update the password
    $stmt = $pdo->prepare("UPDATE drivers SET password = ? WHERE id = ?");
    $stmt->execute([$hashedNewPassword, $driverId]);

    if ($stmt->rowCount() > 0) {
        sendSuccessResponse(['message' => 'Password changed successfully']);
    } else {
        sendErrorResponse('Failed to update password', 500);
    }

} catch (PDOException $e) {
    sendErrorResponse('Database error: ' . $e->getMessage());
}
?>
