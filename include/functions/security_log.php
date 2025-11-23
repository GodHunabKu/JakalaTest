<?php
/**
 * Security Logging System
 * Records security-related events for audit and monitoring
 */

/**
 * Log a security event
 * @param string $event_type Type of event (e.g., 'LOGIN_FAILED', 'CSRF_DETECTED')
 * @param array $data Additional data to log
 * @param int $severity Severity level (1=INFO, 2=WARNING, 3=CRITICAL)
 */
function security_log($event_type, $data = [], $severity = 2) {
    global $database;

    // Gather context information
    $log_entry = [
        'timestamp' => time(),
        'event_type' => $event_type,
        'severity' => $severity,
        'ip_address' => $_SERVER['REMOTE_ADDR'] ?? 'unknown',
        'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? 'unknown',
        'request_uri' => $_SERVER['REQUEST_URI'] ?? 'unknown',
        'account_id' => isset($_SESSION['id']) ? intval($_SESSION['id']) : 0,
        'session_id' => session_id(),
        'data' => json_encode($data)
    ];

    try {
        // Insert into security_logs table
        $stmt = $database->runQuerySqlite('INSERT INTO security_logs (timestamp, event_type, severity, ip_address, user_agent, request_uri, account_id, session_id, data) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)');
        $stmt->execute([
            $log_entry['timestamp'],
            $log_entry['event_type'],
            $log_entry['severity'],
            $log_entry['ip_address'],
            substr($log_entry['user_agent'], 0, 255), // Limit length
            substr($log_entry['request_uri'], 0, 255), // Limit length
            $log_entry['account_id'],
            $log_entry['session_id'],
            $log_entry['data']
        ]);

        // If critical, also log to file
        if ($severity >= 3) {
            $log_file = __DIR__ . '/../../data/security_critical.log';
            $log_message = sprintf(
                "[%s] %s - IP: %s - Account: %d - Data: %s\n",
                date('Y-m-d H:i:s', $log_entry['timestamp']),
                $event_type,
                $log_entry['ip_address'],
                $log_entry['account_id'],
                $log_entry['data']
            );
            @file_put_contents($log_file, $log_message, FILE_APPEND | LOCK_EX);
        }
    } catch (Exception $e) {
        // Fallback to file logging if database fails
        $log_file = __DIR__ . '/../../data/security_fallback.log';
        $log_message = sprintf(
            "[%s] %s - DB_ERROR: %s\n",
            date('Y-m-d H:i:s'),
            $event_type,
            $e->getMessage()
        );
        @file_put_contents($log_file, $log_message, FILE_APPEND | LOCK_EX);
    }
}

/**
 * Get recent security logs
 * @param int $limit Number of logs to retrieve
 * @param int $min_severity Minimum severity level
 * @return array Array of log entries
 */
function security_log_get_recent($limit = 100, $min_severity = 1) {
    global $database;

    try {
        $stmt = $database->runQuerySqlite('SELECT * FROM security_logs WHERE severity >= ? ORDER BY timestamp DESC LIMIT ?');
        $stmt->bindParam(1, $min_severity, PDO::PARAM_INT);
        $stmt->bindParam(2, $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        return [];
    }
}

/**
 * Get security logs for a specific account
 * @param int $account_id Account ID
 * @param int $limit Number of logs to retrieve
 * @return array Array of log entries
 */
function security_log_get_by_account($account_id, $limit = 50) {
    global $database;

    try {
        $stmt = $database->runQuerySqlite('SELECT * FROM security_logs WHERE account_id = ? ORDER BY timestamp DESC LIMIT ?');
        $stmt->bindParam(1, $account_id, PDO::PARAM_INT);
        $stmt->bindParam(2, $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        return [];
    }
}

/**
 * Get security logs by IP address
 * @param string $ip_address IP address
 * @param int $limit Number of logs to retrieve
 * @return array Array of log entries
 */
function security_log_get_by_ip($ip_address, $limit = 50) {
    global $database;

    try {
        $stmt = $database->runQuerySqlite('SELECT * FROM security_logs WHERE ip_address = ? ORDER BY timestamp DESC LIMIT ?');
        $stmt->bindParam(1, $ip_address, PDO::PARAM_STR);
        $stmt->bindParam(2, $limit, PDO::PARAM_INT);
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    } catch (Exception $e) {
        return [];
    }
}

/**
 * Clean up old security logs
 * @param int $max_age Maximum age in seconds (default: 90 days)
 */
function security_log_cleanup($max_age = 7776000) {
    global $database;

    $cutoff_time = time() - $max_age;

    try {
        $stmt = $database->runQuerySqlite('DELETE FROM security_logs WHERE timestamp < ? AND severity < 3');
        $stmt->bindParam(1, $cutoff_time, PDO::PARAM_INT);
        $stmt->execute();
    } catch (Exception $e) {
        // Silently fail
    }
}

/**
 * Count security events by type in last N hours
 * @param string $event_type Event type
 * @param int $hours Number of hours to look back
 * @return int Count of events
 */
function security_log_count_events($event_type, $hours = 24) {
    global $database;

    $cutoff_time = time() - ($hours * 3600);

    try {
        $stmt = $database->runQuerySqlite('SELECT COUNT(*) as count FROM security_logs WHERE event_type = ? AND timestamp >= ?');
        $stmt->bindParam(1, $event_type, PDO::PARAM_STR);
        $stmt->bindParam(2, $cutoff_time, PDO::PARAM_INT);
        $stmt->execute();
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        return intval($result['count']);
    } catch (Exception $e) {
        return 0;
    }
}

/**
 * Admin audit log - specific for admin actions
 * @param string $action Action performed
 * @param array $details Details of the action
 */
function admin_audit_log($action, $details = []) {
    if (!isset($_SESSION['id'])) {
        return;
    }

    $details['admin_id'] = $_SESSION['id'];
    $details['admin_name'] = get_account_name();

    security_log('ADMIN_ACTION_' . strtoupper($action), $details, 2);
}
?>
