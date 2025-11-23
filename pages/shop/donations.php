<!-- Donazioni Page - Sistema BigSmoke -->
<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="admin-quick-access">
    <a href="<?php print $shop_url.'admin/paypal'; ?>" class="admin-btn">
        <i class="fas fa-cog"></i>
        <span>Gestione Donazioni</span>
    </a>
</div>
<?php } ?>

<div class="donations-page">
    <!-- Hero Header -->
    <div class="donations-hero">
        <div class="hero-icon-circle">
            <i class="fas fa-hand-holding-heart"></i>
        </div>
        <h1>Supporta ONE Server</h1>
        <p>Dona per mantenere il server attivo e ottieni MD Coins esclusivi</p>
    </div>

    <!-- Metodi di Pagamento -->
    <div class="content-card">
        <div class="card-header">
            <i class="fas fa-credit-card"></i>
            <h2>Metodi di Pagamento Accettati</h2>
        </div>
        <div class="payment-methods">
            <div class="payment-card">
                <i class="fas fa-money-check-alt"></i>
                <span>Postepay</span>
            </div>
            <div class="payment-card">
                <i class="fab fa-paypal"></i>
                <span>PayPal</span>
            </div>
            <div class="payment-card">
                <i class="fas fa-university"></i>
                <span>Bonifico</span>
            </div>
            <div class="payment-card">
                <i class="fas fa-exchange-alt"></i>
                <span>Revolut</span>
            </div>
        </div>
    </div>

    <!-- Come Donare -->
    <div class="content-card">
        <div class="card-header">
            <i class="fas fa-list-ol"></i>
            <h2>Come Effettuare una Donazione</h2>
        </div>
        <div class="donation-steps">
            <div class="step">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h3>Contatta il Game Master</h3>
                    <p>Invia un messaggio a <strong>[GF]BigSmoke</strong> su Discord o contattalo in-game</p>
                    <div class="contact-badge discord">
                        <i class="fab fa-discord"></i>
                        <span>[GF]BigSmoke</span>
                    </div>
                </div>
            </div>

            <div class="step">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h3>Scegli il tuo pacchetto</h3>
                    <p>Comunica quanti MD Coins desideri acquistare (vedi listino prezzi sotto)</p>
                </div>
            </div>

            <div class="step">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h3>Ricevi le coordinate di pagamento</h3>
                    <p>Il Game Master ti fornirà le coordinate per effettuare il pagamento</p>
                </div>
            </div>

            <div class="step">
                <div class="step-number">4</div>
                <div class="step-content">
                    <h3>Effettua il pagamento</h3>
                    <p>Completa la transazione e invia ricevuta/screenshot al Game Master</p>
                </div>
            </div>

            <div class="step">
                <div class="step-number">5</div>
                <div class="step-content">
                    <h3>Ricevi i tuoi MD Coins</h3>
                    <p>I MD Coins verranno accreditati sul tuo account entro pochi minuti</p>
                </div>
            </div>
        </div>
    </div>

    <!-- Listino Prezzi -->
    <div class="content-card">
        <div class="card-header">
            <i class="fas fa-tags"></i>
            <h2>Listino Prezzi MD Coins</h2>
        </div>

        <div class="pricing-grid">
            <!-- Starter Package -->
            <div class="price-card">
                <div class="package-label">STARTER</div>
                <div class="coin-display">
                    <i class="fas fa-coins"></i>
                    <span class="amount">125</span>
                    <span class="label">MD Coins</span>
                </div>
                <div class="price">5€</div>
            </div>

            <!-- Base Package -->
            <div class="price-card">
                <div class="package-label">BASE</div>
                <div class="coin-display">
                    <i class="fas fa-coins"></i>
                    <span class="amount">250</span>
                    <span class="label">MD Coins</span>
                </div>
                <div class="price">10€</div>
            </div>

            <!-- Premium Package -->
            <div class="price-card">
                <div class="package-label">PREMIUM</div>
                <div class="coin-display">
                    <i class="fas fa-coins"></i>
                    <span class="amount">750</span>
                    <span class="label">MD Coins</span>
                </div>
                <div class="price">30€</div>
            </div>

            <!-- Gold Package -->
            <div class="price-card popular">
                <div class="popular-badge">BEST VALUE</div>
                <div class="package-label gold">GOLD +5%</div>
                <div class="coin-display">
                    <i class="fas fa-coins"></i>
                    <span class="amount">1,312</span>
                    <span class="label">MD Coins</span>
                    <span class="bonus">+62 BONUS</span>
                </div>
                <div class="price">50€</div>
                <div class="bonus-tag">+5% BONUS</div>
            </div>

            <!-- Platinum Package -->
            <div class="price-card popular">
                <div class="popular-badge">BEST VALUE</div>
                <div class="package-label platinum">PLATINUM +10%</div>
                <div class="coin-display">
                    <i class="fas fa-coins"></i>
                    <span class="amount">4,125</span>
                    <span class="label">MD Coins</span>
                    <span class="bonus">+375 BONUS</span>
                </div>
                <div class="price">150€</div>
                <div class="bonus-tag">+10% BONUS</div>
            </div>

            <!-- Diamond Package -->
            <div class="price-card popular">
                <div class="popular-badge">BEST VALUE</div>
                <div class="package-label diamond">DIAMOND +20%</div>
                <div class="coin-display">
                    <i class="fas fa-coins"></i>
                    <span class="amount">9,000</span>
                    <span class="label">MD Coins</span>
                    <span class="bonus">+1,500 BONUS</span>
                </div>
                <div class="price">300€</div>
                <div class="bonus-tag">+20% BONUS</div>
            </div>
        </div>

        <div class="bonus-info-box">
            <i class="fas fa-gift"></i>
            <p>I pacchetti da 50€ in su includono MD Coins bonus! Più doni, più ricevi!</p>
        </div>
    </div>

    <!-- Note Importanti -->
    <div class="content-card alert-card">
        <div class="card-header">
            <i class="fas fa-exclamation-circle"></i>
            <h2>Note Importanti</h2>
        </div>
        <ul class="info-list">
            <li><i class="fas fa-check-circle"></i> Le donazioni sono <strong>volontarie</strong> e supportano i costi del server</li>
            <li><i class="fas fa-check-circle"></i> I MD Coins vengono accreditati <strong>manualmente</strong> dopo la verifica</li>
            <li><i class="fas fa-check-circle"></i> Tempo di accredito: <strong>da pochi minuti a max 24 ore</strong></li>
            <li><i class="fas fa-check-circle"></i> Conserva sempre la <strong>ricevuta del pagamento</strong></li>
            <li><i class="fas fa-check-circle"></i> Per problemi, contatta <strong>[GF]BigSmoke</strong> su Discord</li>
            <li><i class="fas fa-check-circle"></i> Le donazioni <strong>NON sono rimborsabili</strong></li>
        </ul>
    </div>

    <!-- Contatti -->
    <div class="content-card contact-card">
        <div class="card-header">
            <i class="fas fa-headset"></i>
            <h2>Hai Domande?</h2>
        </div>
        <p class="contact-desc">Non esitare a contattare il nostro staff per assistenza:</p>
        <div class="contact-grid">
            <div class="contact-box">
                <i class="fab fa-discord"></i>
                <div class="contact-info">
                    <span class="label">Discord</span>
                    <span class="value">[GF]BigSmoke</span>
                </div>
            </div>
            <div class="contact-box">
                <i class="fas fa-gamepad"></i>
                <div class="contact-info">
                    <span class="label">In-Game</span>
                    <span class="value">[GF]BigSmoke</span>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* Donations Page - Stile Ultra Fedele al Sito */
.donations-page {
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

/* Admin Quick Access */
.admin-quick-access {
    margin-bottom: 30px;
    text-align: right;
}

.admin-btn {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 12px 24px;
    background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);
    color: white;
    border-radius: 8px;
    font-weight: 600;
    transition: var(--transition-smooth);
    box-shadow: var(--shadow-primary);
}

.admin-btn:hover {
    box-shadow: var(--shadow-primary-lg);
    transform: translateY(-2px);
}

/* Hero Header */
.donations-hero {
    background: var(--color-box-bg);
    backdrop-filter: blur(15px);
    border: 1px solid rgba(231, 76, 60, 0.15);
    border-radius: 12px;
    padding: 60px 40px;
    text-align: center;
    margin-bottom: 40px;
    box-shadow: var(--shadow-lg);
    position: relative;
    overflow: hidden;
}

.donations-hero::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    height: 4px;
    background: linear-gradient(90deg, var(--color-primary) 0%, var(--color-primary-light) 100%);
}

.hero-icon-circle {
    width: 100px;
    height: 100px;
    margin: 0 auto 30px;
    background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 10px 40px rgba(231, 76, 60, 0.5);
    animation: pulse 3s ease-in-out infinite;
}

.hero-icon-circle i {
    font-size: 48px;
    color: white;
}

@keyframes pulse {
    0%, 100% { transform: scale(1); box-shadow: 0 10px 40px rgba(231, 76, 60, 0.5); }
    50% { transform: scale(1.05); box-shadow: 0 15px 50px rgba(231, 76, 60, 0.7); }
}

.donations-hero h1 {
    font-family: var(--font-secondary);
    font-size: 36px;
    font-weight: 700;
    color: var(--color-text-light);
    margin-bottom: 15px;
    letter-spacing: 1px;
}

.donations-hero p {
    font-size: 16px;
    color: var(--color-text-dark);
    max-width: 600px;
    margin: 0 auto;
}

/* Content Cards */
.content-card {
    background: var(--color-box-bg);
    backdrop-filter: blur(15px);
    border: 1px solid rgba(231, 76, 60, 0.15);
    border-radius: 12px;
    padding: 30px;
    margin-bottom: 30px;
    box-shadow: var(--shadow-lg);
    transition: var(--transition-smooth);
}

.content-card:hover {
    border-color: rgba(231, 76, 60, 0.3);
    box-shadow: 0 8px 32px rgba(231, 76, 60, 0.2);
}

.card-header {
    display: flex;
    align-items: center;
    gap: 15px;
    margin-bottom: 30px;
    padding-bottom: 20px;
    border-bottom: 1px solid rgba(231, 76, 60, 0.2);
}

.card-header i {
    font-size: 32px;
    color: var(--color-primary);
}

.card-header h2 {
    font-family: var(--font-secondary);
    font-size: 24px;
    font-weight: 700;
    color: var(--color-text-light);
    margin: 0;
}

/* Payment Methods */
.payment-methods {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 20px;
}

.payment-card {
    background: rgba(231, 76, 60, 0.1);
    border: 1px solid rgba(231, 76, 60, 0.2);
    border-radius: 12px;
    padding: 30px 20px;
    text-align: center;
    transition: var(--transition-smooth);
}

.payment-card:hover {
    background: rgba(231, 76, 60, 0.2);
    border-color: rgba(231, 76, 60, 0.5);
    transform: translateY(-5px);
    box-shadow: var(--shadow-primary);
}

.payment-card i {
    font-size: 48px;
    color: var(--color-primary);
    margin-bottom: 15px;
    display: block;
}

.payment-card span {
    display: block;
    font-weight: 600;
    font-size: 14px;
    color: var(--color-text-light);
}

/* Donation Steps */
.donation-steps {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.step {
    display: flex;
    gap: 20px;
    align-items: flex-start;
    background: rgba(255, 255, 255, 0.02);
    border: 1px solid rgba(231, 76, 60, 0.1);
    border-radius: 12px;
    padding: 25px;
    transition: var(--transition-smooth);
}

.step:hover {
    background: rgba(231, 76, 60, 0.05);
    border-color: rgba(231, 76, 60, 0.3);
}

.step-number {
    flex-shrink: 0;
    width: 50px;
    height: 50px;
    background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: var(--font-secondary);
    font-size: 24px;
    font-weight: 700;
    color: white;
    box-shadow: 0 4px 20px rgba(231, 76, 60, 0.4);
}

.step-content h3 {
    font-family: var(--font-secondary);
    font-size: 18px;
    font-weight: 700;
    color: var(--color-text-light);
    margin: 0 0 10px 0;
}

.step-content p {
    color: var(--color-text-dark);
    margin: 0;
    line-height: 1.6;
}

.contact-badge {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 10px 20px;
    background: rgba(88, 101, 242, 0.15);
    border: 1px solid rgba(88, 101, 242, 0.3);
    border-radius: 8px;
    margin-top: 15px;
    transition: var(--transition-smooth);
}

.contact-badge:hover {
    background: rgba(88, 101, 242, 0.25);
    border-color: rgba(88, 101, 242, 0.5);
}

.contact-badge.discord i {
    color: #5865F2;
    font-size: 24px;
}

.contact-badge span {
    font-weight: 700;
    color: var(--color-text-light);
}

/* Pricing Grid */
.pricing-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 30px;
}

.price-card {
    background: rgba(30, 30, 30, 0.8);
    border: 1px solid rgba(231, 76, 60, 0.2);
    border-radius: 12px;
    padding: 30px 20px;
    text-align: center;
    transition: var(--transition-smooth);
    position: relative;
}

.price-card:hover {
    transform: translateY(-8px);
    border-color: rgba(231, 76, 60, 0.6);
    box-shadow: 0 12px 35px rgba(231, 76, 60, 0.4);
}

.price-card.popular {
    border: 2px solid #FFD700;
    background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(30, 30, 30, 0.8) 100%);
}

.popular-badge {
    position: absolute;
    top: -15px;
    left: 50%;
    transform: translateX(-50%);
    background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
    color: #000;
    font-size: 11px;
    font-weight: 900;
    padding: 6px 16px;
    border-radius: 20px;
    letter-spacing: 1px;
    box-shadow: 0 4px 15px rgba(255, 215, 0, 0.5);
}

.package-label {
    background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);
    color: white;
    font-size: 12px;
    font-weight: 900;
    padding: 8px 16px;
    border-radius: 20px;
    display: inline-block;
    margin-bottom: 20px;
    letter-spacing: 1px;
}

.package-label.gold {
    background: linear-gradient(135deg, #FFD700 0%, #FFA500 100%);
    color: #000;
}

.package-label.platinum {
    background: linear-gradient(135deg, #E5E4E2 0%, #9CA3AF 100%);
    color: #000;
}

.package-label.diamond {
    background: linear-gradient(135deg, #B9F2FF 0%, #00A8CC 100%);
    color: #000;
}

.coin-display {
    margin: 25px 0;
}

.coin-display i {
    font-size: 40px;
    color: #FFD700;
    margin-bottom: 15px;
    display: block;
    filter: drop-shadow(0 0 15px rgba(255, 215, 0, 0.6));
}

.coin-display .amount {
    display: block;
    font-family: var(--font-secondary);
    font-size: 40px;
    font-weight: 900;
    color: #FFD700;
    text-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
    margin-bottom: 8px;
}

.coin-display .label {
    display: block;
    font-size: 12px;
    color: var(--color-text-dark);
    text-transform: uppercase;
    letter-spacing: 1px;
}

.coin-display .bonus {
    display: block;
    font-size: 13px;
    color: #FFD700;
    font-weight: 700;
    margin-top: 8px;
}

.price {
    font-family: var(--font-secondary);
    font-size: 32px;
    font-weight: 900;
    color: var(--color-text-light);
    margin-top: 20px;
}

.bonus-tag {
    display: inline-block;
    background: rgba(255, 215, 0, 0.2);
    color: #FFD700;
    font-size: 11px;
    font-weight: 900;
    padding: 6px 12px;
    border-radius: 15px;
    margin-top: 10px;
    letter-spacing: 0.5px;
}

/* Bonus Info Box */
.bonus-info-box {
    background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 215, 0, 0.05) 100%);
    border: 1px solid rgba(255, 215, 0, 0.3);
    border-radius: 12px;
    padding: 20px;
    display: flex;
    align-items: center;
    gap: 15px;
}

.bonus-info-box i {
    font-size: 32px;
    color: #FFD700;
    flex-shrink: 0;
}

.bonus-info-box p {
    margin: 0;
    color: var(--color-text-light);
    font-weight: 600;
}

/* Alert Card */
.alert-card {
    background: linear-gradient(135deg, rgba(231, 76, 60, 0.05) 0%, var(--color-box-bg) 100%);
    border-color: rgba(231, 76, 60, 0.3);
}

.info-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.info-list li {
    display: flex;
    align-items: flex-start;
    gap: 15px;
    margin-bottom: 15px;
    color: var(--color-text-dark);
    line-height: 1.6;
}

.info-list li:last-child {
    margin-bottom: 0;
}

.info-list li i {
    color: var(--color-primary);
    margin-top: 3px;
    flex-shrink: 0;
    font-size: 18px;
}

/* Contact Card */
.contact-card {
    text-align: center;
}

.contact-desc {
    color: var(--color-text-dark);
    margin-bottom: 30px;
    font-size: 15px;
}

.contact-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.contact-box {
    display: flex;
    align-items: center;
    gap: 20px;
    background: rgba(231, 76, 60, 0.1);
    border: 1px solid rgba(231, 76, 60, 0.2);
    border-radius: 12px;
    padding: 25px;
    transition: var(--transition-smooth);
}

.contact-box:hover {
    background: rgba(231, 76, 60, 0.15);
    border-color: rgba(231, 76, 60, 0.5);
    transform: scale(1.02);
}

.contact-box i {
    font-size: 48px;
    color: var(--color-primary);
}

.contact-info {
    text-align: left;
    flex: 1;
}

.contact-info .label {
    display: block;
    font-size: 12px;
    color: var(--color-text-dark);
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 5px;
}

.contact-info .value {
    display: block;
    font-size: 18px;
    font-weight: 700;
    color: var(--color-text-light);
}

/* Responsive */
@media (max-width: 768px) {
    .donations-hero {
        padding: 40px 20px;
    }

    .donations-hero h1 {
        font-size: 28px;
    }

    .pricing-grid {
        grid-template-columns: 1fr;
    }

    .payment-methods {
        grid-template-columns: repeat(2, 1fr);
    }

    .contact-grid {
        grid-template-columns: 1fr;
    }

    .step {
        flex-direction: column;
        align-items: center;
        text-align: center;
    }
}
</style>
