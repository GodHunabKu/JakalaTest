# ONE SHOP - Ultimate Edition

Modern e-commerce platform for Metin2 servers with advanced security features.

## 🚀 Features

- **Modern UI/UX** - Dark theme with smooth animations
- **Secure** - CSRF protection, XSS prevention, rate limiting
- **PayPal Integration** - Secure payment processing
- **Multi-currency** - MD and JD coins support
- **Admin Panel** - Complete shop management
- **Responsive** - Mobile-friendly design

## 📋 Requirements

- PHP 7.4 or higher
- MySQL 5.7+ / MariaDB 10.2+
- Apache with mod_rewrite enabled
- SSL certificate (recommended for production)

## 🔧 Installation

### 1. Clone or upload the shop files

```bash
git clone <repository-url>
cd shop
```

### 2. Configure environment

Copy the example environment file:

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```env
SHOP_URL=https://yourdomain.com/shop/
SERVER_NAME=YourServerName

DB_HOST=your_database_host
DB_USER=your_database_user
DB_PASSWORD=your_database_password

PAYPAL_EMAIL=your-paypal@email.com
PAYPAL_MODE=live

SESSION_LIFETIME=3600
ENABLE_CSRF_PROTECTION=true
APP_ENV=production
```

### 3. Set file permissions

```bash
chmod 755 shop/
chmod 644 shop/.env
chmod 755 shop/include/
chmod 755 shop/images/
```

### 4. Create logs directory

```bash
mkdir -p shop/logs
chmod 750 shop/logs
```

### 5. Database setup

The shop uses your existing Metin2 database (`account`, `player`, `log`) and a local SQLite database for shop data (`include/db/site.db`).

Make sure your database user has appropriate permissions.

## 🔒 Security Configuration

### HTTPS/SSL (Highly Recommended)

Edit `.htaccess` and uncomment these lines:

```apache
RewriteCond %{HTTPS} off
RewriteRule ^(.*)$ https://%{HTTP_HOST}%{REQUEST_URI} [L,R=301]
```

### Session Security

Sessions are automatically configured with secure parameters when `.env` is loaded:
- HttpOnly cookies
- SameSite policy
- Secure flag (when using HTTPS)

### CSRF Protection

CSRF protection is enabled by default. All forms include CSRF tokens automatically.

To disable (NOT recommended):
```env
ENABLE_CSRF_PROTECTION=false
```

### Rate Limiting

Login attempts are limited to 5 per 5 minutes per IP address.

### File Protection

The `.htaccess` file protects:
- `.env` configuration file
- Log files
- SQLite database files
- Sensitive PHP files

## 📝 Configuration Options

### PayPal Setup

1. Set your PayPal email in `.env`
2. For testing, use `PAYPAL_MODE=sandbox`
3. For production, use `PAYPAL_MODE=live`
4. Configure IPN URL: `https://yourdomain.com/shop/index.php?p=pay`

### Language

Supported languages: EN, IT, DE, FR, ES, RO, TR, PL

Configure in `include/functions/language.php`

### Admin Access

Admin level is controlled by the `web_admin` field in the `account` table.
- Level 9+ = Full admin access
- Level 0 = Regular user

Set admin level:
```sql
UPDATE account SET web_admin = 9 WHERE login = 'your_username';
```

## 🛠️ Maintenance

### Logs

Security logs are stored in `logs/security.log`

View recent logs:
```bash
tail -f logs/security.log
```

### Clearing rate limits

Rate limit data is stored in system temp directory. It auto-expires after the time window.

### Session cleanup

PHP handles session cleanup automatically. Adjust `session.gc_maxlifetime` in php.ini if needed.

## 🔄 Updating

When updating the shop:

1. **Backup your `.env` file**
2. **Backup your database**
3. Pull new changes
4. Compare `.env.example` with your `.env` for new options
5. Clear any caches if needed

## ⚠️ Security Best Practices

1. **NEVER commit `.env` to git** - It contains sensitive credentials
2. **Use HTTPS in production** - Protects user data in transit
3. **Keep PHP updated** - Security patches are important
4. **Monitor logs regularly** - Check for suspicious activity
5. **Backup regularly** - Both database and files
6. **Use strong PayPal password** - Enable 2FA on PayPal account

## 🐛 Troubleshooting

### "ERROR: .env file not found"

Copy `.env.example` to `.env` and configure it.

### "Database credentials not configured"

Check your `.env` file has correct `DB_HOST`, `DB_USER`, and `DB_PASSWORD`.

### "CSRF token validation failed"

- Clear your browser cookies
- Make sure cookies are enabled
- Check that your session directory is writable

### PayPal IPN not working

1. Check PayPal IPN URL is correct
2. Check logs in `logs/security.log`
3. Verify PayPal email in `.env` matches your account
4. Ensure SSL is working if using live mode

### Login rate limiting

If locked out, wait 5 minutes or clear temp files:
```bash
rm /tmp/rate_limit_*
```

## 📞 Support

For issues or questions:
- Check the logs first
- Review security configuration
- Verify .env settings
- Check file permissions

## 📄 License

Copyright © 2017-2024. All rights reserved.

## 🔐 Security Notes

**Password Hashing**: The shop maintains compatibility with Metin2's legacy password system (SHA1) while adding additional security layers:
- Rate limiting on login attempts
- Session regeneration
- Enhanced fingerprinting
- Secure logging

**Future Enhancement**: For new user registrations (if implemented), use the modern `hash_password()` function with bcrypt.

## 🎨 Customization

### Themes

Main CSS files:
- `assets/css/shop-one-ultimate10.css` - Main theme
- `assets/css/shop-one-fix-v5.css` - Fixes and patches

Edit CSS variables in `shop-one-ultimate10.css`:
```css
:root {
    --one-scarlet: #DC143C;
    --one-dark-red: #8B0000;
    --bg-primary: #0D0D0D;
    /* ... */
}
```

### Logo

Replace `images/logo3.png` with your logo.

## ✅ Post-Installation Checklist

- [ ] `.env` file configured
- [ ] Database connection tested
- [ ] Admin account created
- [ ] PayPal configured and tested
- [ ] HTTPS enabled
- [ ] File permissions set correctly
- [ ] Logs directory created
- [ ] Test login works
- [ ] Test purchase flow
- [ ] IPN tested (use PayPal sandbox)
- [ ] Backup system in place

---

**Built with ❤️ for Metin2 communities**
