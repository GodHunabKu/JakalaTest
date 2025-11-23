<?php
/**
 * Rate Limiting System
 * Prevents brute force attacks and API abuse
 */

/**
 * Check if rate limit is exceeded for a given action
 * @param string $action The action identifier (e.g., 'login', 'api_call')
 * @param int $max_attempts Maximum attempts allowed
 * @param int $time_window Time window in seconds
 * @param string $identifier Optional identifier (default: IP address)
 * @return bool True if rate limit exceeded, false otherwise
 */
function rate_limit_check($action, $max_attempts = 5, $time_window = 900, $identifier = null) {
    global $database;

    // Use IP address if no identifier provided
    if ($identifier === null) {
        $identifier = $_SERVER['REMOTE_ADDR'];
    }

    $key = $action . '_' . $identifier;
    $current_time = time();

    try {
        // Get existing attempts from database
        $stmt = $database->runQuerySqlite('SELECT attempts, first_attempt, last_attempt FROM rate_limits WHERE action_key = ? LIMIT 1');
        $stmt->bindParam(1, $key, PDO::PARAM_STR);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            $attempts = intval($result['attempts']);
            $first_attempt = intval($result['first_attempt']);
            $last_attempt = intval($result['last_attempt']);

            // Check if time window has expired
            if (($current_time - $first_attempt) > $time_window) {
                // Reset counter
                rate_limit_reset($action, $identifier);
                return false;
            }

            // Check if max attempts exceeded
            if ($attempts >= $max_attempts) {
                // Calculate remaining time
                $remaining_time = $time_window - ($current_time - $first_attempt);

                // Log the attempt
                security_log('RATE_LIMIT_EXCEEDED', [
                    'action' => $action,
                    'identifier' => $identifier,
                    'attempts' => $attempts,
                    'remaining_time' => $remaining_time
                ]);

                return true;
            }
        }

        return false;
    } catch (Exception $e) {
        // On error, allow the action but log it
        security_log('RATE_LIMIT_ERROR', ['error' => $e->getMessage()]);
        return false;
    }
}

/**
 * Record an attempt for rate limiting
 * @param string $action The action identifier
 * @param string $identifier Optional identifier (default: IP address)
 */
function rate_limit_record($action, $identifier = null) {
    global $database;

    if ($identifier === null) {
        $identifier = $_SERVER['REMOTE_ADDR'];
    }

    $key = $action . '_' . $identifier;
    $current_time = time();

    try {
        // Check if record exists
        $stmt = $database->runQuerySqlite('SELECT attempts, first_attempt FROM rate_limits WHERE action_key = ? LIMIT 1');
        $stmt->bindParam(1, $key, PDO::PARAM_STR);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            // Update existing record
            $stmt = $database->runQuerySqlite('UPDATE rate_limits SET attempts = attempts + 1, last_attempt = ? WHERE action_key = ?');
            $stmt->bindParam(1, $current_time, PDO::PARAM_INT);
            $stmt->bindParam(2, $key, PDO::PARAM_STR);
            $stmt->execute();
        } else {
            // Create new record
            $stmt = $database->runQuerySqlite('INSERT INTO rate_limits (action_key, attempts, first_attempt, last_attempt) VALUES (?, 1, ?, ?)');
            $stmt->bindParam(1, $key, PDO::PARAM_STR);
            $stmt->bindParam(2, $current_time, PDO::PARAM_INT);
            $stmt->bindParam(3, $current_time, PDO::PARAM_INT);
            $stmt->execute();
        }
    } catch (Exception $e) {
        // Silently fail
        security_log('RATE_LIMIT_RECORD_ERROR', ['error' => $e->getMessage()]);
    }
}

/**
 * Reset rate limit for an action
 * @param string $action The action identifier
 * @param string $identifier Optional identifier (default: IP address)
 */
function rate_limit_reset($action, $identifier = null) {
    global $database;

    if ($identifier === null) {
        $identifier = $_SERVER['REMOTE_ADDR'];
    }

    $key = $action . '_' . $identifier;

    try {
        $stmt = $database->runQuerySqlite('DELETE FROM rate_limits WHERE action_key = ?');
        $stmt->bindParam(1, $key, PDO::PARAM_STR);
        $stmt->execute();
    } catch (Exception $e) {
        // Silently fail
    }
}

/**
 * Clean up old rate limit records
 * Call this periodically (e.g., via cron)
 * @param int $max_age Maximum age in seconds (default: 24 hours)
 */
function rate_limit_cleanup($max_age = 86400) {
    global $database;

    $cutoff_time = time() - $max_age;

    try {
        $stmt = $database->runQuerySqlite('DELETE FROM rate_limits WHERE last_attempt < ?');
        $stmt->bindParam(1, $cutoff_time, PDO::PARAM_INT);
        $stmt->execute();
    } catch (Exception $e) {
        // Silently fail
    }
}

/**
 * Get remaining attempts before rate limit
 * @param string $action The action identifier
 * @param int $max_attempts Maximum attempts allowed
 * @param string $identifier Optional identifier
 * @return int Remaining attempts
 */
function rate_limit_get_remaining($action, $max_attempts = 5, $identifier = null) {
    global $database;

    if ($identifier === null) {
        $identifier = $_SERVER['REMOTE_ADDR'];
    }

    $key = $action . '_' . $identifier;

    try {
        $stmt = $database->runQuerySqlite('SELECT attempts FROM rate_limits WHERE action_key = ? LIMIT 1');
        $stmt->bindParam(1, $key, PDO::PARAM_STR);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($result) {
            $remaining = $max_attempts - intval($result['attempts']);
            return max(0, $remaining);
        }

        return $max_attempts;
    } catch (Exception $e) {
        return $max_attempts;
    }
}
?>
