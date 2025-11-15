# Security Policy

## 🔒 Security Features

This shop includes the following security features:

### 1. Environment Variables (.env)
- Database credentials stored securely
- Never committed to git
- Separated from code

### 2. CSRF Protection
- Token-based protection on all forms
- Automatic validation
- Session-based tokens

### 3. Input Validation
- Whitelist-based page routing
- ID validation with ranges
- Username/password format validation
- SQL injection prevention via PDO prepared statements

### 4. XSS Prevention
- Output sanitization with `safe_output()`
- HTML entity encoding
- Content Security Policy ready

### 5. Rate Limiting
- Login attempts: 5 per 5 minutes per IP
- Automatic lockout
- Logging of failed attempts

### 6. Session Security
- HttpOnly cookies
- SameSite policy
- Secure cookies (HTTPS)
- Session regeneration on login
- Enhanced fingerprinting

### 7. File Protection
- .htaccess blocks sensitive files
- No directory listing
- Logs protected
- Database files protected

### 8. Secure Logging
- Security events logged
- No sensitive data in logs
- Timestamped with IP addresses
- Separate security log file

## 🚨 Reporting Vulnerabilities

If you discover a security vulnerability:

1. **DO NOT** open a public issue
2. Email the administrator directly
3. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## 🔄 Security Updates

### Current Version
- CSRF Protection: ✅ Enabled
- Rate Limiting: ✅ Enabled
- Input Validation: ✅ Enabled
- XSS Protection: ✅ Enabled
- Secure Sessions: ✅ Enabled

### Known Limitations

1. **Password Hashing**: Currently uses Metin2's legacy SHA1 system for compatibility.
   - **Mitigation**: Rate limiting, account lockout, logging
   - **Future**: Migrate to bcrypt for new accounts

2. **SQLite Database**: Shop data stored in SQLite file
   - **Mitigation**: Protected via .htaccess
   - **Recommendation**: Move outside web root if possible

## 🛡️ Security Checklist

### Before Going Live

- [ ] `.env` file has strong passwords
- [ ] `APP_ENV=production` in `.env`
- [ ] HTTPS enabled and working
- [ ] `.htaccess` rules active
- [ ] File permissions set correctly (755 for dirs, 644 for files)
- [ ] `display_errors=0` in production
- [ ] Logs directory protected
- [ ] Database backups configured
- [ ] PayPal IPN tested
- [ ] Admin accounts secured
- [ ] Default credentials changed

### Regular Maintenance

- [ ] Review security logs weekly
- [ ] Update PHP regularly
- [ ] Monitor failed login attempts
- [ ] Check file integrity
- [ ] Verify backup systems
- [ ] Test restore procedures

## 📋 Security Headers

The `.htaccess` file sets these security headers:

```
X-Content-Type-Options: nosniff
X-XSS-Protection: 1; mode=block
X-Frame-Options: SAMEORIGIN
Referrer-Policy: strict-origin-when-cross-origin
```

### Recommended Additional Headers

Add to your Apache configuration or `.htaccess`:

```apache
# Content Security Policy
Header set Content-Security-Policy "default-src 'self'; script-src 'self' 'unsafe-inline' https://code.jquery.com https://cdn.jsdelivr.net; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src 'self' https://fonts.gstatic.com; img-src 'self' data: https:;"

# Strict Transport Security (HTTPS only)
Header set Strict-Transport-Security "max-age=31536000; includeSubDomains"
```

## 🔐 Password Policy

### For Admin Accounts
- Minimum 12 characters
- Mix of uppercase, lowercase, numbers, symbols
- Not based on dictionary words
- Changed every 90 days
- Unique (not reused)

### For Users
Current system allows 5-16 characters (Metin2 limitation).

## 🚫 Common Vulnerabilities - FIXED

| Vulnerability | Status | Fix |
|--------------|--------|-----|
| SQL Injection | ✅ Fixed | PDO prepared statements |
| XSS | ✅ Fixed | Output sanitization |
| CSRF | ✅ Fixed | Token validation |
| Session Fixation | ✅ Fixed | Session regeneration |
| Path Traversal | ✅ Fixed | Input whitelist |
| Info Disclosure | ✅ Fixed | Error handling |
| Brute Force | ✅ Mitigated | Rate limiting |
| File Inclusion | ✅ Fixed | Whitelist routing |

## 📞 Emergency Response

### If Compromised

1. **Immediately**:
   - Take shop offline
   - Change all passwords
   - Revoke API keys
   - Check logs

2. **Investigate**:
   - Review security logs
   - Check file integrity
   - Examine database for unauthorized changes
   - Identify attack vector

3. **Remediate**:
   - Patch vulnerability
   - Restore from clean backup
   - Update all credentials
   - Notify affected users if needed

4. **Prevent**:
   - Document incident
   - Improve security measures
   - Update monitoring
   - Review access controls

## 🔍 Monitoring

### What to Monitor

1. **Security Logs** (`logs/security.log`)
   - Failed login attempts
   - Rate limit violations
   - Invalid input attempts
   - CSRF failures

2. **System Logs** (Apache error logs)
   - PHP errors
   - File access errors
   - Permission issues

3. **Database**
   - Unusual query patterns
   - Unexpected data changes
   - Failed connections

### Alert Thresholds

- 10+ failed logins in 10 minutes → Investigate
- Multiple CSRF failures → Possible attack
- Unexpected admin level changes → Security breach
- Unusual PayPal transactions → Verify manually

## 📚 Resources

- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [PHP Security Guide](https://www.php.net/manual/en/security.php)
- [PayPal IPN Guide](https://developer.paypal.com/docs/api-basics/notifications/ipn/)

## ✅ Compliance

This shop implements security best practices for:
- Input validation
- Output encoding
- Authentication
- Session management
- Cryptography (legacy system)
- Error handling
- Logging

---

**Last Updated**: 2024
**Security Version**: 2.0
