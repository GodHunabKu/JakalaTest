<?php
/**
 * Security Functions
 * CSRF Protection, Input Validation, XSS Prevention
 */

// ============================================
// CSRF PROTECTION
// ============================================

/**
 * Generate CSRF Token
 */
function csrf_token() {
    if (!isset($_SESSION['csrf_token']) || !isset($_SESSION['csrf_token_time']) ||
        (time() - $_SESSION['csrf_token_time']) > SESSION_LIFETIME) {
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        $_SESSION['csrf_token_time'] = time();
    }
    return $_SESSION['csrf_token'];
}

/**
 * Get CSRF Token Field (for forms)
 */
function csrf_field() {
    return '<input type="hidden" name="csrf_token" value="' . csrf_token() . '">';
}

/**
 * Verify CSRF Token
 */
function csrf_verify() {
    if (!CSRF_PROTECTION) {
        return true;
    }

    $token = isset($_POST['csrf_token']) ? $_POST['csrf_token'] : '';
    $session_token = isset($_SESSION['csrf_token']) ? $_SESSION['csrf_token'] : '';

    if (empty($token) || empty($session_token)) {
        return false;
    }

    // Use hash_equals to prevent timing attacks
    return hash_equals($session_token, $token);
}

/**
 * Check CSRF or die
 */
function csrf_check() {
    if (!csrf_verify()) {
        http_response_code(403);
        die('CSRF token validation failed. Please refresh the page and try again.');
    }
}

// ============================================
// INPUT VALIDATION & SANITIZATION
// ============================================

/**
 * Validate page parameter with whitelist
 */
function validate_page($page) {
    $allowed_pages = [
        'home', 'items', 'item', 'login', 'logout',
        'categories', 'add_items', 'add_items_bonus',
        'settings', 'paypal', 'coins', 'pay'
    ];

    return in_array($page, $allowed_pages, true) ? $page : 'home';
}

/**
 * Validate language code
 */
function validate_language($lang) {
    $allowed_languages = ['en', 'it', 'de', 'fr', 'es', 'ro', 'tr', 'pl'];
    return in_array($lang, $allowed_languages, true) ? $lang : 'en';
}

/**
 * Validate and sanitize integer ID
 */
function validate_id($id, $min = 1, $max = PHP_INT_MAX) {
    $id = filter_var($id, FILTER_VALIDATE_INT);
    if ($id === false || $id < $min || $id > $max) {
        return false;
    }
    return $id;
}

/**
 * Sanitize string for output (prevent XSS)
 */
function safe_output($string, $encoding = 'UTF-8') {
    return htmlspecialchars($string, ENT_QUOTES | ENT_HTML5, $encoding);
}

/**
 * Sanitize string for HTML attributes
 */
function safe_attr($string) {
    return htmlspecialchars($string, ENT_QUOTES, 'UTF-8');
}

/**
 * Sanitize email
 */
function validate_email($email) {
    return filter_var($email, FILTER_VALIDATE_EMAIL);
}

/**
 * Validate username (alphanumeric + underscore, 5-64 chars)
 */
function validate_username($username) {
    if (strlen($username) < 5 || strlen($username) > 64) {
        return false;
    }
    return preg_match('/^[a-zA-Z0-9_]+$/', $username);
}

/**
 * Validate password (5-16 chars as per current system)
 */
function validate_password($password) {
    $len = strlen($password);
    return $len >= 5 && $len <= 16;
}

// ============================================
// PASSWORD HASHING (Modern PHP)
// ============================================

/**
 * Hash password using modern bcrypt
 * NOTE: This is for NEW registrations. Existing passwords use old system.
 */
function hash_password($password) {
    return password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
}

/**
 * Verify password against hash
 */
function verify_password($password, $hash) {
    return password_verify($password, $hash);
}

/**
 * Legacy Metin2 password hash (for compatibility)
 * DO NOT USE FOR NEW PASSWORDS
 */
function legacy_hash_password($password) {
    return strtoupper("*" . sha1(sha1($password, true)));
}

/**
 * Verify legacy password
 */
function verify_legacy_password($password, $stored_hash) {
    $computed_hash = legacy_hash_password($password);
    return hash_equals($stored_hash, $computed_hash);
}

// ============================================
// RATE LIMITING
// ============================================

/**
 * Simple rate limiting for login attempts
 */
function check_rate_limit($key, $max_attempts = 5, $time_window = 300) {
    $cache_file = sys_get_temp_dir() . '/rate_limit_' . md5($key) . '.txt';

    $attempts = [];
    if (file_exists($cache_file)) {
        $data = file_get_contents($cache_file);
        $attempts = json_decode($data, true) ?: [];
    }

    // Remove old attempts outside time window
    $now = time();
    $attempts = array_filter($attempts, function($timestamp) use ($now, $time_window) {
        return ($now - $timestamp) < $time_window;
    });

    // Check if exceeded
    if (count($attempts) >= $max_attempts) {
        return false;
    }

    // Add new attempt
    $attempts[] = $now;
    file_put_contents($cache_file, json_encode($attempts));

    return true;
}

/**
 * Clear rate limit for a key (after successful login)
 */
function clear_rate_limit($key) {
    $cache_file = sys_get_temp_dir() . '/rate_limit_' . md5($key) . '.txt';
    if (file_exists($cache_file)) {
        unlink($cache_file);
    }
}

// ============================================
// SESSION SECURITY
// ============================================

/**
 * Regenerate session ID to prevent fixation
 */
function regenerate_session() {
    if (session_status() === PHP_SESSION_ACTIVE) {
        session_regenerate_id(true);
    }
}

/**
 * Enhanced session fingerprint
 */
function get_session_fingerprint() {
    $ip = $_SERVER['REMOTE_ADDR'] ?? '';
    $user_agent = $_SERVER['HTTP_USER_AGENT'] ?? '';

    // Use a more secure combination
    return hash('sha256', $ip . $user_agent . session_id());
}

/**
 * Validate session fingerprint
 */
function validate_session_fingerprint() {
    if (!isset($_SESSION['fingerprint'])) {
        $_SESSION['fingerprint'] = get_session_fingerprint();
        return true;
    }

    return hash_equals($_SESSION['fingerprint'], get_session_fingerprint());
}

// ============================================
// SQL INJECTION PREVENTION HELPERS
// ============================================

/**
 * Prepare safe column name for ORDER BY, SELECT
 */
function safe_column_name($column, $allowed_columns) {
    return in_array($column, $allowed_columns, true) ? $column : $allowed_columns[0];
}

/**
 * Sanitize table name
 */
function safe_table_name($table, $allowed_tables) {
    return in_array($table, $allowed_tables, true) ? $table : null;
}

// ============================================
// LOGGING (Secure)
// ============================================

/**
 * Secure logging without sensitive data
 */
function secure_log($message, $level = 'INFO') {
    $log_file = __DIR__ . '/../../logs/security.log';
    $log_dir = dirname($log_file);

    if (!is_dir($log_dir)) {
        @mkdir($log_dir, 0750, true);
    }

    $timestamp = date('[Y-m-d H:i:s]');
    $ip = $_SERVER['REMOTE_ADDR'] ?? 'UNKNOWN';
    $log_entry = "$timestamp [$level] [IP: $ip] $message" . PHP_EOL;

    @file_put_contents($log_file, $log_entry, FILE_APPEND | LOCK_EX);
}
