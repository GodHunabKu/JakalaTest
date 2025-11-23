<?php
/**
 * Security Migration Script (Direct SQLite Connection)
 * Creates necessary tables for security features
 * Run this once to set up security infrastructure
 */

echo "=== Security Migration Script (Direct) ===\n\n";

try {
    // Connect directly to SQLite database
    $db_path = __DIR__ . '/../include/db/site.db';

    if (!file_exists(dirname($db_path))) {
        mkdir(dirname($db_path), 0755, true);
        echo "Created database directory\n";
    }

    $pdo = new PDO("sqlite:" . $db_path);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "Connected to SQLite database: $db_path\n\n";

    // Create rate_limits table
    echo "Creating rate_limits table...\n";
    $pdo->exec('CREATE TABLE IF NOT EXISTS rate_limits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_key TEXT NOT NULL UNIQUE,
        attempts INTEGER DEFAULT 0,
        first_attempt INTEGER NOT NULL,
        last_attempt INTEGER NOT NULL
    )');
    echo "✓ rate_limits table created\n\n";

    // Create security_logs table
    echo "Creating security_logs table...\n";
    $pdo->exec('CREATE TABLE IF NOT EXISTS security_logs (
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
    echo "✓ security_logs table created\n\n";

    // Create indexes for better performance
    echo "Creating indexes...\n";
    $pdo->exec('CREATE INDEX IF NOT EXISTS idx_rate_limits_key ON rate_limits(action_key)');
    $pdo->exec('CREATE INDEX IF NOT EXISTS idx_security_logs_timestamp ON security_logs(timestamp)');
    $pdo->exec('CREATE INDEX IF NOT EXISTS idx_security_logs_event_type ON security_logs(event_type)');
    $pdo->exec('CREATE INDEX IF NOT EXISTS idx_security_logs_account_id ON security_logs(account_id)');
    $pdo->exec('CREATE INDEX IF NOT EXISTS idx_security_logs_ip ON security_logs(ip_address)');
    echo "✓ Indexes created\n\n";

    echo "=== Migration completed successfully! ===\n";
    echo "\nYou can now use the security features:\n";
    echo "- CSRF protection\n";
    echo "- Rate limiting\n";
    echo "- Security logging\n";
    echo "\nDatabase location: $db_path\n";

} catch (Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
    echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
    exit(1);
}
?>
