<?php
/**
 * Security Migration Script
 * Creates necessary tables for security features
 * Run this once to set up security infrastructure
 */

require_once __DIR__ . '/../config.php';
require_once __DIR__ . '/../include/classes/user.php';

$database = new USER($host, $user, $password);

echo "=== Security Migration Script ===\n\n";

try {
    // Create rate_limits table
    echo "Creating rate_limits table...\n";
    $stmt = $database->runQuerySqlite('CREATE TABLE IF NOT EXISTS rate_limits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_key TEXT NOT NULL UNIQUE,
        attempts INTEGER DEFAULT 0,
        first_attempt INTEGER NOT NULL,
        last_attempt INTEGER NOT NULL
    )');
    $stmt->execute();
    echo "✓ rate_limits table created\n\n";

    // Create security_logs table
    echo "Creating security_logs table...\n";
    $stmt = $database->runQuerySqlite('CREATE TABLE IF NOT EXISTS security_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        timestamp INTEGER NOT NULL,
        event_type TEXT NOT NULL,
        severity INTEGER DEFAULT 2,
        ip_address TEXT,
        user_agent TEXT,
        request_uri TEXT,
        account_id INTEGER DEFAULT 0,
        session_id TEXT,
        data TEXT
    )');
    $stmt->execute();
    echo "✓ security_logs table created\n\n";

    // Create indexes for better performance
    echo "Creating indexes...\n";
    $stmt = $database->runQuerySqlite('CREATE INDEX IF NOT EXISTS idx_rate_limits_key ON rate_limits(action_key)');
    $stmt->execute();
    $stmt = $database->runQuerySqlite('CREATE INDEX IF NOT EXISTS idx_security_logs_timestamp ON security_logs(timestamp)');
    $stmt->execute();
    $stmt = $database->runQuerySqlite('CREATE INDEX IF NOT EXISTS idx_security_logs_event_type ON security_logs(event_type)');
    $stmt->execute();
    $stmt = $database->runQuerySqlite('CREATE INDEX IF NOT EXISTS idx_security_logs_account_id ON security_logs(account_id)');
    $stmt->execute();
    $stmt = $database->runQuerySqlite('CREATE INDEX IF NOT EXISTS idx_security_logs_ip ON security_logs(ip_address)');
    $stmt->execute();
    echo "✓ Indexes created\n\n";

    echo "=== Migration completed successfully! ===\n";
    echo "\nYou can now use the security features:\n";
    echo "- CSRF protection\n";
    echo "- Rate limiting\n";
    echo "- Security logging\n";

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    exit(1);
}
?>
