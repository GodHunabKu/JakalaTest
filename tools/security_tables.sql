-- ========================================
-- SECURITY TABLES MIGRATION
-- Run this script to create security tables
-- ========================================

-- Create rate_limits table
CREATE TABLE IF NOT EXISTS rate_limits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_key TEXT NOT NULL UNIQUE,
    attempts INTEGER DEFAULT 0,
    first_attempt INTEGER NOT NULL,
    last_attempt INTEGER NOT NULL
);

-- Create security_logs table
CREATE TABLE IF NOT EXISTS security_logs (
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
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_rate_limits_key ON rate_limits(action_key);
CREATE INDEX IF NOT EXISTS idx_security_logs_timestamp ON security_logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_security_logs_event_type ON security_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_security_logs_account_id ON security_logs(account_id);
CREATE INDEX IF NOT EXISTS idx_security_logs_ip ON security_logs(ip_address);

-- Verify tables were created
SELECT 'rate_limits table:' as info, COUNT(*) as count FROM rate_limits;
SELECT 'security_logs table:' as info, COUNT(*) as count FROM security_logs;
SELECT 'Setup complete!' as status;
