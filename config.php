<?php
// ============================================
// STYLESPHERE - Database Configuration
// ============================================

// Database credentials
$host = 'localhost';
$dbname = 'stylesphere';
$username = 'root';
$password = '';

// Enable error reporting for development
error_reporting(E_ALL);
ini_set('display_errors', 1);

// Set timezone
date_default_timezone_set('Asia/Dhaka');

try {
    // Create PDO connection
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    $pdo->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
    
    // Start session if not already started
    if (session_status() === PHP_SESSION_NONE) {
        session_start();
    }
    
} catch(PDOException $e) {
    // Log error and show user-friendly message
    error_log("Connection failed: " . $e->getMessage());
    die("❌ Database connection failed. Please check your configuration.");
}

// Helper function for JSON responses
function jsonResponse($success, $data = [], $message = '') {
    header('Content-Type: application/json');
    echo json_encode([
        'success' => $success,
        'data' => $data,
        'message' => $message
    ]);
    exit;
}

// Helper function to escape output
function escapeOutput($string) {
    return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
}

// Helper function to format currency
function formatCurrency($amount) {
    return '৳' . number_format($amount, 2);
}

// Helper function to generate order number
function generateOrderNumber() {
    return 'ORD' . date('Ymd') . rand(1000, 9999);
}

// Helper function to generate tracking number
function generateTrackingNumber() {
    return 'TRK' . date('Ymd') . rand(10000, 99999);
}

// Helper function to generate return request ID
function generateReturnRequestId() {
    return 'RET' . date('Ymd') . rand(1000, 9999);
}

// Helper function to generate coupon code
function generateCouponCode($length = 8) {
    $characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    $code = '';
    for ($i = 0; $i < $length; $i++) {
        $code .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $code;
}

// Helper function to calculate user tier
function calculateUserTier($totalSpent) {
    if ($totalSpent >= 100000) return ['tier' => 'Platinum', 'discount' => 12];
    if ($totalSpent >= 50000) return ['tier' => 'Gold', 'discount' => 10];
    if ($totalSpent >= 20000) return ['tier' => 'Silver', 'discount' => 5];
    return ['tier' => 'Bronze', 'discount' => 0];
}

// Helper function to update user tier
function updateUserTier($pdo, $userId) {
    try {
        // Calculate total spent
        $stmt = $pdo->prepare("SELECT COALESCE(SUM(total), 0) as total_spent FROM orders WHERE user_id = ? AND payment_confirmed = 1 AND status != 'Cancelled'");
        $stmt->execute([$userId]);
        $result = $stmt->fetch();
        $totalSpent = $result['total_spent'] ?? 0;
        
        $tierInfo = calculateUserTier($totalSpent);
        
        // Update user tier
        $stmt = $pdo->prepare("UPDATE users SET tier = ?, total_spent = ? WHERE id = ?");
        $stmt->execute([$tierInfo['tier'], $totalSpent, $userId]);
        
        return $tierInfo;
    } catch (PDOException $e) {
        error_log("Error updating user tier: " . $e->getMessage());
        return null;
    }
}

// Helper function to get user by email
function getUserByEmail($pdo, $email) {
    $stmt = $pdo->prepare("SELECT * FROM users WHERE email = ?");
    $stmt->execute([$email]);
    return $stmt->fetch();
}

// Helper function to get product by ID
function getProductById($pdo, $id) {
    $stmt = $pdo->prepare("SELECT * FROM products WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch();
}

// Helper function to get order by ID
function getOrderById($pdo, $id) {
    $stmt = $pdo->prepare("SELECT * FROM orders WHERE id = ?");
    $stmt->execute([$id]);
    return $stmt->fetch();
}

// Helper function to get order by order_number
function getOrderByNumber($pdo, $orderNumber) {
    $stmt = $pdo->prepare("SELECT * FROM orders WHERE order_number = ?");
    $stmt->execute([$orderNumber]);
    return $stmt->fetch();
}

// Helper function to validate coupon
function validateCoupon($pdo, $code, $subtotal, $userEmail) {
    $stmt = $pdo->prepare("SELECT * FROM coupons WHERE code = ? AND is_active = 1");
    $stmt->execute([$code]);
    $coupon = $stmt->fetch();
    
    if (!$coupon) {
        return ['valid' => false, 'error' => 'Invalid coupon code'];
    }
    
    // Check if coupon has expired
    if ($coupon['end_date'] && strtotime($coupon['end_date']) < time()) {
        return ['valid' => false, 'error' => 'Coupon has expired'];
    }
    
    // Check if coupon has started
    if ($coupon['start_date'] && strtotime($coupon['start_date']) > time()) {
        return ['valid' => false, 'error' => 'Coupon is not yet active'];
    }
    
    // Check min order amount
    if ($coupon['min_order_amount'] > 0 && $subtotal < $coupon['min_order_amount']) {
        return ['valid' => false, 'error' => 'Minimum order amount is ৳' . number_format($coupon['min_order_amount'])];
    }
    
    // Check usage limit
    if ($coupon['usage_limit'] && $coupon['used_count'] >= $coupon['usage_limit']) {
        return ['valid' => false, 'error' => 'Coupon usage limit has been reached'];
    }
    
    // Check user usage limit
    if ($coupon['user_limit_per_user'] && $userEmail) {
        $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM coupon_usage WHERE coupon_id = ? AND user_email = ?");
        $stmt->execute([$coupon['id'], $userEmail]);
        $usage = $stmt->fetch();
        if ($usage['count'] >= $coupon['user_limit_per_user']) {
            return ['valid' => false, 'error' => 'You have already used this coupon'];
        }
    }
    
    return ['valid' => true, 'coupon' => $coupon];
}

// Helper function to calculate discount
function calculateDiscount($coupon, $subtotal) {
    if ($coupon['discount_type'] === 'percent') {
        $discount = ($subtotal * $coupon['discount_value']) / 100;
        if ($coupon['max_discount'] && $discount > $coupon['max_discount']) {
            $discount = $coupon['max_discount'];
        }
    } else {
        $discount = $coupon['discount_value'];
    }
    return min($discount, $subtotal);
}

// Helper function to log coupon usage
function logCouponUsage($pdo, $couponId, $userEmail, $orderId, $discountAmount) {
    try {
        $stmt = $pdo->prepare("INSERT INTO coupon_usage (coupon_id, user_email, order_id, discount_amount) VALUES (?, ?, ?, ?)");
        $stmt->execute([$couponId, $userEmail, $orderId, $discountAmount]);
        
        // Increment used count
        $stmt = $pdo->prepare("UPDATE coupons SET used_count = used_count + 1 WHERE id = ?");
        $stmt->execute([$couponId]);
        
        return true;
    } catch (PDOException $e) {
        error_log("Error logging coupon usage: " . $e->getMessage());
        return false;
    }
}
?>