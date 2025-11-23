<?php
/**
 * CSRF Protection System
 * Provides token generation and validation to prevent Cross-Site Request Forgery attacks
 */

/**
 * Generate a CSRF token and store it in session
 * @return string The generated token
 */
function csrf_generate_token() {
    if (!isset($_SESSION['csrf_token']) || !isset($_SESSION['csrf_token_time']) || (time() - $_SESSION['csrf_token_time']) > 3600) {
        // Generate new token (32 bytes = 64 hex chars)
        $_SESSION['csrf_token'] = bin2hex(random_bytes(32));
        $_SESSION['csrf_token_time'] = time();
    }
    return $_SESSION['csrf_token'];
}

/**
 * Get the current CSRF token
 * @return string|null The current token or null if not set
 */
function csrf_get_token() {
    return isset($_SESSION['csrf_token']) ? $_SESSION['csrf_token'] : null;
}

/**
 * Validate CSRF token from POST/GET request
 * @param string $token The token to validate
 * @return bool True if valid, false otherwise
 */
function csrf_validate_token($token) {
    if (!isset($_SESSION['csrf_token']) || empty($token)) {
        return false;
    }

    // Use hash_equals to prevent timing attacks
    return hash_equals($_SESSION['csrf_token'], $token);
}

/**
 * Generate HTML hidden input field with CSRF token
 * @return string HTML input field
 */
function csrf_token_field() {
    $token = csrf_generate_token();
    return '<input type="hidden" name="csrf_token" value="' . htmlspecialchars($token, ENT_QUOTES, 'UTF-8') . '">';
}

/**
 * Validate CSRF token from request and die if invalid
 * Call this at the beginning of POST handlers
 */
function csrf_validate_or_die() {
    $token = isset($_POST['csrf_token']) ? $_POST['csrf_token'] : (isset($_GET['csrf_token']) ? $_GET['csrf_token'] : '');

    if (!csrf_validate_token($token)) {
        http_response_code(403);
        die(json_encode([
            'success' => false,
            'error' => 'CSRF token validation failed. Please refresh the page and try again.'
        ]));
    }
}

/**
 * Get CSRF token for AJAX requests (JSON format)
 * @return array
 */
function csrf_get_token_ajax() {
    return [
        'csrf_token' => csrf_generate_token()
    ];
}
?>
