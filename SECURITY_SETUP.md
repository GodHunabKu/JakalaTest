# 🔒 Security Setup Guide

## Panoramica

Questo documento descrive le funzionalità di sicurezza implementate nello shop e come configurarle correttamente.

## ✅ Funzionalità Implementate

### 1. **CSRF Protection**
- Token di sicurezza per tutte le form e API
- Validazione lato server di ogni richiesta POST
- Protezione contro Cross-Site Request Forgery attacks

### 2. **Rate Limiting**
- Login: Max 5 tentativi ogni 15 minuti
- API calls: Max 30 richieste al minuto
- Blocco automatico temporaneo in caso di abuso

### 3. **Security Logging**
- Log di tutti gli eventi di sicurezza
- Tracciamento di login success/fail
- Audit log per azioni admin
- Log di tentativi CSRF e rate limit exceeded

### 4. **Session Security**
- HttpOnly cookies abilitato
- SameSite cookie policy: Strict
- Secure cookies se HTTPS attivo
- Session timeout: 30 minuti di inattività
- Session regeneration al login
- Session fingerprinting migliorato

### 5. **Content Security Policy (CSP)**
- Header CSP implementato
- Protezione contro XSS
- Frame-ancestors: none (anti-clickjacking)
- X-Content-Type-Options: nosniff

### 6. **Input Validation**
- Whitelist per language_code (previene SQL injection)
- Sanitizzazione HTML con htmlspecialchars
- Validazione rigorosa degli input utente

### 7. **Admin Audit Log**
- Tracciamento di tutte le azioni admin
- Log di creazione/modifica/eliminazione categorie e item
- Timestamp e identificazione admin per ogni azione

---

## 📋 Setup Iniziale

### **PASSO 1: Migrazione Database**

Le funzionalità di sicurezza richiedono due nuove tabelle nel database SQLite.

**Opzione A: Esegui lo script SQL direttamente**

Connettiti al database SQLite (`include/db/site.db`) e esegui:

\`\`\`sql
CREATE TABLE IF NOT EXISTS rate_limits (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    action_key TEXT NOT NULL UNIQUE,
    attempts INTEGER DEFAULT 0,
    first_attempt INTEGER NOT NULL,
    last_attempt INTEGER NOT NULL
);

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

-- Indici per performance
CREATE INDEX IF NOT EXISTS idx_rate_limits_key ON rate_limits(action_key);
CREATE INDEX IF NOT EXISTS idx_security_logs_timestamp ON security_logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_security_logs_event_type ON security_logs(event_type);
CREATE INDEX IF NOT EXISTS idx_security_logs_account_id ON security_logs(account_id);
CREATE INDEX IF NOT EXISTS idx_security_logs_ip ON security_logs(ip_address);
\`\`\`

**Opzione B: Usa il client SQLite**

\`\`\`bash
sqlite3 include/db/site.db < tools/security_tables.sql
\`\`\`

### **PASSO 2: Verifica Permessi**

Assicurati che il file `include/db/site.db` abbia i permessi corretti:

\`\`\`bash
chmod 644 include/db/site.db
chown www-data:www-data include/db/site.db  # O il tuo utente web server
\`\`\`

### **PASSO 3: Crea Directory per Log**

\`\`\`bash
mkdir -p data
chmod 755 data
\`\`\`

### **PASSO 4: Abilita HTTPS (Raccomandato)**

Per abilitare i secure cookies, configura HTTPS sul tuo server:

1. Ottieni un certificato SSL (Let's Encrypt gratuito)
2. Configura il web server (Apache/Nginx) per HTTPS
3. I secure cookies verranno automaticamente abilitati

---

## 🛡️ Configurazione Avanzata

### Rate Limiting Personalizzato

Modifica i parametri in `include/functions/header.php`:

\`\`\`php
// Login rate limiting
rate_limit_check('login', 5, 900)  // 5 attempts, 15 minutes

// API rate limiting (in api/shop_api.php)
rate_limit_check('api_call', 30, 60)  // 30 requests, 1 minute
\`\`\`

### Session Timeout

Modifica il timeout in `include/functions/header.php`:

\`\`\`php
// Session timeout (default: 30 minutes = 1800 seconds)
if (isset($_SESSION['last_activity']) && (time() - $_SESSION['last_activity']) > 1800) {
    // Change 1800 to your desired timeout
}
\`\`\`

### CSP Policy

La Content Security Policy è configurata in `include/functions/header.php`. Modificala se necessario per il tuo setup.

---

## 📊 Monitoraggio Sicurezza

### Visualizzare i Log di Sicurezza

I log sono memorizzati nella tabella `security_logs`. Query utili:

\`\`\`sql
-- Ultimi eventi critici
SELECT * FROM security_logs WHERE severity >= 3 ORDER BY timestamp DESC LIMIT 50;

-- Login falliti nelle ultime 24h
SELECT * FROM security_logs
WHERE event_type = 'LOGIN_FAILED'
AND timestamp > strftime('%s', 'now', '-1 day')
ORDER BY timestamp DESC;

-- Tentativi CSRF
SELECT * FROM security_logs
WHERE event_type LIKE '%CSRF%'
ORDER BY timestamp DESC;

-- Azioni admin
SELECT * FROM security_logs
WHERE event_type LIKE 'ADMIN_ACTION%'
ORDER BY timestamp DESC;
\`\`\`

### Livelli di Severity

- **1 = INFO**: Eventi informativi (login success, gift sent)
- **2 = WARNING**: Eventi da monitorare (login failed, rate limit)
- **3 = CRITICAL**: Eventi critici (CSRF detected, rate limit exceeded)

---

## 🧹 Manutenzione

### Pulizia Log Vecchi

Esegui periodicamente (es. via cron):

\`\`\`sql
-- Elimina log > 90 giorni (esclusi critici)
DELETE FROM security_logs
WHERE timestamp < strftime('%s', 'now', '-90 days')
AND severity < 3;

-- Elimina rate limits > 24h
DELETE FROM rate_limits
WHERE last_attempt < strftime('%s', 'now', '-1 day');
\`\`\`

Script PHP per automazione (crea un cron job):

\`\`\`bash
# Aggiungi a crontab (esegue ogni giorno alle 3 AM)
0 3 * * * php /path/to/shop/tools/cleanup_security.php
\`\`\`

---

## 🔍 Testing

### Test CSRF Protection

1. Prova a fare login senza il token CSRF (rimuovilo dall'HTML)
2. Dovresti vedere: "Invalid security token"

### Test Rate Limiting

1. Prova a fare login con password errata 6 volte di seguito
2. Al 6° tentativo dovresti essere bloccato per 15 minuti
3. Messaggio: "Too many login attempts"

### Test Session Security

1. Fai login
2. Aspetta 31 minuti senza interagire
3. La prossima azione dovrebbe riportarti al login

---

## ⚠️ Troubleshooting

### "Could not find driver" durante migrazione

Il driver SQLite non è installato su PHP. Installa:

\`\`\`bash
# Ubuntu/Debian
sudo apt-get install php-sqlite3

# CentOS/RHEL
sudo yum install php-sqlite3

# Riavvia web server
sudo service apache2 restart  # o nginx
\`\`\`

### Rate limiting non funziona

Verifica che le tabelle esistano:

\`\`\`bash
sqlite3 include/db/site.db "SELECT * FROM rate_limits;"
\`\`\`

### CSRF token validation failed

1. Verifica che `session_start()` sia chiamato prima di usare CSRF
2. Controlla che il token sia incluso nelle form
3. Verifica che non ci siano problemi di caching

---

## 📞 Supporto

Per problemi o domande sulla sicurezza, consulta:

- Log di sicurezza in `security_logs`
- Log critici in `data/security_critical.log`
- Log di fallback in `data/security_fallback.log`

---

## 🎯 Best Practices

1. **Monitora regolarmente i log** di sicurezza
2. **Pulisci i vecchi log** per mantenere le performance
3. **Usa HTTPS sempre** in produzione
4. **Fai backup regolari** del database SQLite
5. **Aggiorna PHP** alla versione più recente
6. **Limita accesso admin** solo a IP fidati (firewall)
7. **Usa password forti** per account admin

---

**Versione**: 1.0
**Data**: 2025-11-23
**Status**: ✅ Production Ready
