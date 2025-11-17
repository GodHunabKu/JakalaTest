<?php
/**
 * ONE SHOP - Secure Configuration
 * This file loads configuration from .env file
 */

// Function to load .env file
function loadEnv($path) {
    if (!file_exists($path)) {
        die('ERROR: .env file not found. Please copy .env.example to .env and configure it.');
    }

    $lines = file($path, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        // Skip comments
        if (strpos(trim($line), '#') === 0) {
            continue;
        }

        // Parse KEY=VALUE
        if (strpos($line, '=') !== false) {
            list($key, $value) = explode('=', $line, 2);
            $key = trim($key);
            $value = trim($value);

            // Remove quotes if present
            if (preg_match('/^(["\'])(.*)\1$/', $value, $matches)) {
                $value = $matches[2];
            }

            // Set as environment variable
            if (!array_key_exists($key, $_ENV)) {
                $_ENV[$key] = $value;
                putenv("$key=$value");
            }
        }
    }
}

// Load environment variables
loadEnv(__DIR__ . '/.env');

// Helper function to get env variable with fallback
function env($key, $default = null) {
    $value = getenv($key);
    if ($value === false) {
        return $default;
    }

    // Convert string booleans to actual booleans
    if ($value === 'true') return true;
    if ($value === 'false') return false;
    if ($value === 'null') return null;

    return $value;
}

// Shop Configuration
$shop_url = env('SHOP_URL', 'http://localhost/shop/');
$server_name = env('SERVER_NAME', 'Metin2');

// Database Configuration
$host = env('DB_HOST');
$user = env('DB_USER');
$password = env('DB_PASSWORD');

// Validate required configuration
if (!$host || !$user || !$password) {
    die('ERROR: Database credentials not configured. Please check your .env file.');
}

// PayPal Configuration
$paypal_email = env('PAYPAL_EMAIL');
$paypal_mode = env('PAYPAL_MODE', 'live'); // 'sandbox' or 'live'

if (!$paypal_email) {
    error_log('WARNING: PayPal email not configured');
}

// Security Configuration
define('CSRF_PROTECTION', env('ENABLE_CSRF_PROTECTION', true));
define('SESSION_LIFETIME', env('SESSION_LIFETIME', 3600));

// Note: Session ini_set() calls moved to header.php (before session_start())

// Error reporting - NEVER show errors in production
if (env('APP_ENV') === 'development') {
    error_reporting(E_ALL);
    ini_set('display_errors', 1);
} else {
    error_reporting(E_ALL);
    ini_set('display_errors', 0);
    ini_set('log_errors', 1);
}
