<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="admin-actions-bar">
    <a href="<?php print $shop_url.'admin/paypal'; ?>" class="btn-admin btn-admin-info">
        <i class="fas fa-cog"></i>
        <span>Gestione Donazioni</span>
    </a>
</div>
<?php } ?>

<div class="shop-content-wrapper">
    <!-- Page Header -->
    <div class="page-header">
        <div class="page-title">
            <i class="fas fa-hand-holding-usd"></i>
            <h1>Donazioni e MD Coins</h1>
        </div>
        <div class="page-breadcrumb">
            <a href="<?php print $shop_url; ?>">Home</a>
            <i class="fas fa-chevron-right"></i>
            <span>Donazioni</span>
        </div>
    </div>

    <!-- Informazioni Donazioni -->
    <div class="donation-info-card">
        <div class="donation-header">
            <div class="header-icon">
                <i class="fas fa-heart"></i>
            </div>
            <h2>Come Ottenere MD Coins</h2>
            <p>Supporta il server e ottieni MD Coins per acquistare oggetti esclusivi</p>
        </div>

        <div class="donation-content">
            <!-- Metodi di Pagamento -->
            <div class="payment-methods-section">
                <h3><i class="fas fa-credit-card"></i> Metodi di Pagamento Accettati</h3>
                <div class="payment-methods-grid">
                    <div class="payment-method">
                        <i class="fas fa-money-check-alt"></i>
                        <span>Postepay</span>
                    </div>
                    <div class="payment-method">
                        <i class="fab fa-paypal"></i>
                        <span>PayPal</span>
                    </div>
                    <div class="payment-method">
                        <i class="fas fa-university"></i>
                        <span>Bonifico Bancario</span>
                    </div>
                    <div class="payment-method">
                        <i class="fas fa-exchange-alt"></i>
                        <span>Revolut</span>
                    </div>
                </div>
            </div>

            <!-- Come Donare -->
            <div class="how-to-donate-section">
                <h3><i class="fas fa-info-circle"></i> Come Effettuare una Donazione</h3>
                <div class="steps-list">
                    <div class="step-item">
                        <div class="step-number">1</div>
                        <div class="step-content">
                            <h4>Contatta il Game Master</h4>
                            <p>Invia un messaggio a <strong>[GF]BigSmoke</strong> su Discord oppure contattalo in-game</p>
                            <div class="contact-badge">
                                <i class="fab fa-discord"></i>
                                <span>[GF]BigSmoke</span>
                            </div>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-number">2</div>
                        <div class="step-content">
                            <h4>Scegli il tuo pacchetto</h4>
                            <p>Comunica quanti MD Coins desideri acquistare (vedi listino prezzi sotto)</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-number">3</div>
                        <div class="step-content">
                            <h4>Ricevi le coordinate di pagamento</h4>
                            <p>Il Game Master ti fornirà le coordinate per effettuare il pagamento tramite il metodo da te scelto</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-number">4</div>
                        <div class="step-content">
                            <h4>Effettua il pagamento</h4>
                            <p>Completa la transazione e invia la ricevuta/screenshot al Game Master</p>
                        </div>
                    </div>
                    <div class="step-item">
                        <div class="step-number">5</div>
                        <div class="step-content">
                            <h4>Ricevi i tuoi MD Coins</h4>
                            <p>Una volta verificato il pagamento, i MD Coins verranno accreditati sul tuo account entro pochi minuti</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Listino Prezzi -->
            <div class="pricing-section">
                <h3><i class="fas fa-tags"></i> Listino Prezzi MD Coins</h3>
                <div class="pricing-grid">
                    <div class="price-package">
                        <div class="package-badge">STARTER</div>
                        <div class="package-coins">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                            <span class="coins-amount">125</span>
                            <span class="coins-label">MD Coins</span>
                        </div>
                        <div class="package-price">
                            <span class="price">5€</span>
                        </div>
                    </div>

                    <div class="price-package">
                        <div class="package-badge">BASE</div>
                        <div class="package-coins">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                            <span class="coins-amount">250</span>
                            <span class="coins-label">MD Coins</span>
                        </div>
                        <div class="package-price">
                            <span class="price">10€</span>
                        </div>
                    </div>

                    <div class="price-package">
                        <div class="package-badge">PREMIUM</div>
                        <div class="package-coins">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                            <span class="coins-amount">750</span>
                            <span class="coins-label">MD Coins</span>
                        </div>
                        <div class="package-price">
                            <span class="price">30€</span>
                        </div>
                    </div>

                    <div class="price-package popular">
                        <div class="package-badge">GOLD +5%</div>
                        <div class="package-coins">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                            <span class="coins-amount">1,312</span>
                            <span class="coins-label">MD Coins</span>
                            <span class="bonus-label">(1,250 + 62 BONUS)</span>
                        </div>
                        <div class="package-price">
                            <span class="price">50€</span>
                            <span class="bonus-info">+5% BONUS</span>
                        </div>
                    </div>

                    <div class="price-package popular">
                        <div class="package-badge">PLATINUM +10%</div>
                        <div class="package-coins">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                            <span class="coins-amount">4,125</span>
                            <span class="coins-label">MD Coins</span>
                            <span class="bonus-label">(3,750 + 375 BONUS)</span>
                        </div>
                        <div class="package-price">
                            <span class="price">150€</span>
                            <span class="bonus-info">+10% BONUS</span>
                        </div>
                    </div>

                    <div class="price-package popular">
                        <div class="package-badge">DIAMOND +20%</div>
                        <div class="package-coins">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                            <span class="coins-amount">9,000</span>
                            <span class="coins-label">MD Coins</span>
                            <span class="bonus-label">(7,500 + 1,500 BONUS)</span>
                        </div>
                        <div class="package-price">
                            <span class="price">300€</span>
                            <span class="bonus-info">+20% BONUS</span>
                        </div>
                    </div>
                </div>

                <div class="pricing-note pulsing">
                    <i class="fas fa-star"></i>
                    <p>I pacchetti da 50€ in su includono MD Coins bonus! Più doni, più ricevi!</p>
                </div>
            </div>

            <!-- Note Importanti -->
            <div class="important-notes">
                <h3><i class="fas fa-exclamation-triangle"></i> Note Importanti</h3>
                <ul>
                    <li><i class="fas fa-check"></i> Le donazioni sono <strong>volontarie</strong> e servono a supportare i costi del server</li>
                    <li><i class="fas fa-check"></i> I MD Coins vengono accreditati <strong>manualmente</strong> dopo la verifica del pagamento</li>
                    <li><i class="fas fa-check"></i> Tempo di accredito: <strong>da pochi minuti a massimo 24 ore</strong></li>
                    <li><i class="fas fa-check"></i> Conserva sempre la <strong>ricevuta del pagamento</strong> come prova</li>
                    <li><i class="fas fa-check"></i> Per qualsiasi problema, contatta <strong>[GF]BigSmoke</strong> su Discord</li>
                    <li><i class="fas fa-check"></i> Le donazioni <strong>NON sono rimborsabili</strong></li>
                </ul>
            </div>

            <!-- Contatti -->
            <div class="contact-section">
                <h3><i class="fas fa-headset"></i> Hai Domande?</h3>
                <p>Se hai dubbi o necessiti di assistenza, non esitare a contattare il nostro staff:</p>
                <div class="contact-box">
                    <div class="contact-item">
                        <i class="fab fa-discord"></i>
                        <div class="contact-info">
                            <span class="contact-label">Discord</span>
                            <span class="contact-value">[GF]BigSmoke</span>
                        </div>
                    </div>
                    <div class="contact-item">
                        <i class="fas fa-gamepad"></i>
                        <div class="contact-info">
                            <span class="contact-label">In-Game</span>
                            <span class="contact-value">[GF]BigSmoke</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* Donation Page Styles */
.donation-info-card {
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 20px;
    overflow: hidden;
    box-shadow: var(--shadow-md);
}

.donation-header {
    background: linear-gradient(135deg, rgba(220, 20, 60, 0.2) 0%, rgba(139, 0, 0, 0.2) 100%);
    padding: 30px;
    text-align: center;
    border-bottom: 1px solid var(--glass-border);
}

.donation-header .header-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 20px;
    background: linear-gradient(135deg, var(--one-scarlet) 0%, rgba(139, 0, 0, 0.8) 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 10px 30px rgba(220, 20, 60, 0.4);
}

.donation-header .header-icon i {
    font-size: 36px;
    color: white;
}

.donation-header h2 {
    font-family: var(--font-heading);
    font-size: 28px;
    font-weight: 900;
    color: var(--text-primary);
    margin: 0 0 10px 0;
    text-transform: uppercase;
    letter-spacing: 2px;
}

.donation-header p {
    color: var(--text-secondary);
    margin: 0;
    font-size: 15px;
}

.donation-content {
    padding: 30px;
}

.donation-content h3 {
    font-family: var(--font-heading);
    font-size: 20px;
    font-weight: 900;
    color: var(--text-primary);
    margin: 0 0 20px 0;
    display: flex;
    align-items: center;
    gap: 10px;
}

.donation-content h3 i {
    color: var(--one-scarlet);
}

/* Payment Methods */
.payment-methods-section {
    margin-bottom: 40px;
}

.payment-methods-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 15px;
}

.payment-method {
    background: rgba(220, 20, 60, 0.1);
    border: 1px solid rgba(220, 20, 60, 0.3);
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    transition: all 0.3s ease;
}

.payment-method:hover {
    background: rgba(220, 20, 60, 0.2);
    transform: translateY(-3px);
    box-shadow: 0 5px 20px rgba(220, 20, 60, 0.3);
}

.payment-method i {
    font-size: 32px;
    color: var(--one-scarlet);
    margin-bottom: 10px;
    display: block;
}

.payment-method span {
    display: block;
    font-weight: 600;
    color: var(--text-primary);
}

/* Steps */
.how-to-donate-section {
    margin-bottom: 40px;
}

.steps-list {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.step-item {
    display: flex;
    gap: 20px;
    align-items: flex-start;
    background: rgba(255, 255, 255, 0.03);
    padding: 20px;
    border-radius: 12px;
    border: 1px solid var(--glass-border);
}

.step-number {
    flex-shrink: 0;
    width: 40px;
    height: 40px;
    background: linear-gradient(135deg, var(--one-scarlet) 0%, rgba(139, 0, 0, 0.8) 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-family: var(--font-heading);
    font-size: 18px;
    font-weight: 900;
    color: white;
    box-shadow: 0 4px 15px rgba(220, 20, 60, 0.4);
}

.step-content h4 {
    font-family: var(--font-heading);
    font-size: 16px;
    font-weight: 700;
    color: var(--text-primary);
    margin: 0 0 8px 0;
}

.step-content p {
    color: var(--text-secondary);
    margin: 0;
    line-height: 1.6;
}

.contact-badge {
    display: inline-flex;
    align-items: center;
    gap: 8px;
    background: rgba(88, 101, 242, 0.2);
    border: 1px solid rgba(88, 101, 242, 0.4);
    padding: 8px 16px;
    border-radius: 8px;
    margin-top: 10px;
}

.contact-badge i {
    color: #5865F2;
    font-size: 18px;
}

.contact-badge span {
    font-weight: 600;
    color: var(--text-primary);
}

/* Pricing */
.pricing-section {
    margin-bottom: 40px;
}

.pricing-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 20px;
    margin-bottom: 20px;
}

.price-package {
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 16px;
    padding: 25px;
    text-align: center;
    transition: all 0.3s ease;
    position: relative;
}

.price-package:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(220, 20, 60, 0.3);
    border-color: var(--one-scarlet);
}

.price-package.popular {
    border: 2px solid var(--one-gold);
    background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 215, 0, 0.05) 100%);
}

.price-package.popular::before {
    content: "BEST VALUE";
    position: absolute;
    top: -12px;
    left: 50%;
    transform: translateX(-50%);
    background: linear-gradient(135deg, var(--one-gold) 0%, #DAA520 100%);
    color: black;
    font-size: 11px;
    font-weight: 900;
    padding: 4px 12px;
    border-radius: 20px;
    letter-spacing: 1px;
}

.package-badge {
    background: linear-gradient(135deg, var(--one-scarlet) 0%, rgba(139, 0, 0, 0.8) 100%);
    color: white;
    font-size: 11px;
    font-weight: 900;
    padding: 6px 12px;
    border-radius: 20px;
    display: inline-block;
    margin-bottom: 15px;
    letter-spacing: 1px;
}

.package-coins {
    margin: 20px 0;
}

.package-coins img {
    width: 40px;
    height: 40px;
    margin-bottom: 10px;
}

.package-coins .coins-amount {
    display: block;
    font-family: var(--font-heading);
    font-size: 32px;
    font-weight: 900;
    color: var(--one-gold);
    line-height: 1;
    text-shadow: 0 0 15px rgba(255, 215, 0, 0.5);
    margin-bottom: 5px;
}

.package-coins .coins-label {
    display: block;
    font-size: 12px;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 1px;
}

.package-coins .bonus-label {
    display: block;
    font-size: 11px;
    color: var(--one-gold);
    margin-top: 5px;
    font-weight: 600;
}

.package-price .price {
    display: block;
    font-family: var(--font-heading);
    font-size: 28px;
    font-weight: 900;
    color: var(--text-primary);
    margin-bottom: 5px;
}

.package-price .bonus-info {
    display: block;
    font-size: 12px;
    color: var(--one-gold);
    font-weight: 700;
    text-transform: uppercase;
}

.pricing-note {
    background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 215, 0, 0.05) 100%);
    border: 1px solid rgba(255, 215, 0, 0.3);
    border-radius: 12px;
    padding: 15px 20px;
    display: flex;
    align-items: center;
    gap: 15px;
}

.pricing-note i {
    font-size: 24px;
    color: var(--one-gold);
    flex-shrink: 0;
}

.pricing-note p {
    margin: 0;
    color: var(--text-primary);
    font-size: 14px;
}

/* Important Notes */
.important-notes {
    margin-bottom: 40px;
    background: rgba(220, 20, 60, 0.05);
    border: 1px solid rgba(220, 20, 60, 0.2);
    border-radius: 12px;
    padding: 25px;
}

.important-notes ul {
    list-style: none;
    padding: 0;
    margin: 0;
}

.important-notes li {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    margin-bottom: 12px;
    color: var(--text-secondary);
    line-height: 1.6;
}

.important-notes li:last-child {
    margin-bottom: 0;
}

.important-notes li i {
    color: var(--one-scarlet);
    margin-top: 3px;
    flex-shrink: 0;
}

/* Contact Section */
.contact-section {
    text-align: center;
}

.contact-section p {
    color: var(--text-secondary);
    margin-bottom: 20px;
}

.contact-box {
    display: flex;
    justify-content: center;
    gap: 30px;
    flex-wrap: wrap;
}

.contact-item {
    display: flex;
    align-items: center;
    gap: 15px;
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    padding: 20px 30px;
    border-radius: 12px;
}

.contact-item i {
    font-size: 32px;
    color: var(--one-scarlet);
}

.contact-info {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
}

.contact-label {
    font-size: 12px;
    color: var(--text-secondary);
    text-transform: uppercase;
    letter-spacing: 1px;
}

.contact-value {
    font-family: var(--font-heading);
    font-size: 16px;
    font-weight: 700;
    color: var(--text-primary);
}

/* Responsive */
@media (max-width: 768px) {
    .pricing-grid {
        grid-template-columns: 1fr;
    }

    .payment-methods-grid {
        grid-template-columns: repeat(2, 1fr);
    }

    .contact-box {
        flex-direction: column;
        align-items: stretch;
    }

    .contact-item {
        justify-content: center;
    }
}

/* ANIMAZIONI POTENTI */
@keyframes slideInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

@keyframes float {
    0%, 100% {
        transform: translateY(0px);
    }
    50% {
        transform: translateY(-10px);
    }
}

@keyframes pulse {
    0%, 100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.05);
    }
}

@keyframes shine {
    0% {
        background-position: -200% center;
    }
    100% {
        background-position: 200% center;
    }
}

@keyframes glow {
    0%, 100% {
        box-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
    }
    50% {
        box-shadow: 0 0 40px rgba(255, 215, 0, 0.8), 0 0 60px rgba(255, 215, 0, 0.6);
    }
}

@keyframes rotate {
    from {
        transform: rotate(0deg);
    }
    to {
        transform: rotate(360deg);
    }
}

/* Applicazione animazioni */
.donation-header {
    animation: slideInUp 0.8s ease-out;
}

.payment-method {
    animation: slideInUp 0.8s ease-out;
    animation-fill-mode: both;
}

.payment-method:nth-child(1) { animation-delay: 0.1s; }
.payment-method:nth-child(2) { animation-delay: 0.2s; }
.payment-method:nth-child(3) { animation-delay: 0.3s; }
.payment-method:nth-child(4) { animation-delay: 0.4s; }

.step-item {
    animation: slideInUp 0.8s ease-out;
    animation-fill-mode: both;
}

.step-item:nth-child(1) { animation-delay: 0.2s; }
.step-item:nth-child(2) { animation-delay: 0.3s; }
.step-item:nth-child(3) { animation-delay: 0.4s; }
.step-item:nth-child(4) { animation-delay: 0.5s; }
.step-item:nth-child(5) { animation-delay: 0.6s; }

.price-package {
    animation: slideInUp 0.8s ease-out, float 3s ease-in-out infinite;
    animation-fill-mode: both;
}

.price-package:nth-child(1) { animation-delay: 0.1s, 0.1s; }
.price-package:nth-child(2) { animation-delay: 0.2s, 0.3s; }
.price-package:nth-child(3) { animation-delay: 0.3s, 0.5s; }
.price-package:nth-child(4) { animation-delay: 0.4s, 0.7s; }
.price-package:nth-child(5) { animation-delay: 0.5s, 0.9s; }
.price-package:nth-child(6) { animation-delay: 0.6s, 1.1s; }

.price-package.popular {
    animation: slideInUp 0.8s ease-out, float 3s ease-in-out infinite, glow 2s ease-in-out infinite;
}

.pricing-note.pulsing {
    animation: pulse 2s ease-in-out infinite;
}

.header-icon {
    animation: float 3s ease-in-out infinite, rotate 20s linear infinite;
}

.package-coins img {
    animation: float 2s ease-in-out infinite;
}

.contact-badge {
    animation: pulse 2s ease-in-out infinite;
}

/* Effetto shine sui badge */
.package-badge {
    background: linear-gradient(135deg, var(--one-scarlet) 0%, rgba(139, 0, 0, 0.8) 50%, var(--one-scarlet) 100%);
    background-size: 200% auto;
    animation: shine 3s linear infinite;
}

.price-package.popular .package-badge {
    background: linear-gradient(135deg, var(--one-gold) 0%, #FFD700 50%, var(--one-gold) 100%);
    background-size: 200% auto;
    animation: shine 3s linear infinite;
}

/* Hover enhancements */
.price-package:hover {
    animation: float 3s ease-in-out infinite, pulse 0.5s ease-out;
}

.payment-method:hover {
    animation: pulse 0.5s ease-out;
}

/* Particle effect container */
.donation-info-card {
    position: relative;
    overflow: visible;
}

@keyframes particle-float {
    0% {
        transform: translateY(0) rotate(0deg);
        opacity: 0;
    }
    10% {
        opacity: 1;
    }
    90% {
        opacity: 1;
    }
    100% {
        transform: translateY(-100px) rotate(360deg);
        opacity: 0;
    }
}

.particle {
    position: absolute;
    pointer-events: none;
    font-size: 20px;
    animation: particle-float 3s ease-out forwards;
}
</style>

<script>
// JAVASCRIPT POTENTE PER ANIMAZIONI DONAZIONI
document.addEventListener('DOMContentLoaded', function() {

    // Counter animato per i numeri delle coins
    function animateCounter(element, target, duration = 2000) {
        let start = 0;
        const increment = target / (duration / 16);
        const timer = setInterval(() => {
            start += increment;
            if (start >= target) {
                element.textContent = target.toLocaleString('it-IT');
                clearInterval(timer);
            } else {
                element.textContent = Math.floor(start).toLocaleString('it-IT');
            }
        }, 16);
    }

    // Anima i numeri al caricamento
    const coinAmounts = document.querySelectorAll('.coins-amount');
    coinAmounts.forEach((element, index) => {
        const originalText = element.textContent.replace(/,/g, '');
        const target = parseInt(originalText);
        setTimeout(() => {
            animateCounter(element, target, 1500);
        }, 500 + (index * 200));
    });

    // Effetto particelle quando hover sui pacchetti
    const packages = document.querySelectorAll('.price-package');
    packages.forEach(pkg => {
        pkg.addEventListener('mouseenter', function(e) {
            createParticles(this);
        });
    });

    function createParticles(element) {
        const particles = ['💎', '✨', '⭐', '💰', '🎁', '🌟'];
        for (let i = 0; i < 5; i++) {
            const particle = document.createElement('span');
            particle.className = 'particle';
            particle.textContent = particles[Math.floor(Math.random() * particles.length)];
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = '50%';
            particle.style.animationDelay = (i * 0.1) + 's';
            element.appendChild(particle);

            setTimeout(() => particle.remove(), 3000);
        }
    }

    // Effetto click sui pacchetti
    packages.forEach(pkg => {
        pkg.addEventListener('click', function(e) {
            // Crea effetto ripple
            const ripple = document.createElement('div');
            ripple.style.position = 'absolute';
            ripple.style.width = '20px';
            ripple.style.height = '20px';
            ripple.style.borderRadius = '50%';
            ripple.style.background = 'rgba(255, 215, 0, 0.6)';
            ripple.style.left = e.offsetX + 'px';
            ripple.style.top = e.offsetY + 'px';
            ripple.style.transform = 'translate(-50%, -50%)';
            ripple.style.animation = 'pulse 0.6s ease-out';
            ripple.style.pointerEvents = 'none';

            this.appendChild(ripple);
            setTimeout(() => ripple.remove(), 600);

            // Mostra messaggio incoraggiante
            showEncouragementMessage(this);
        });
    });

    function showEncouragementMessage(element) {
        const messages = [
            '💎 Ottima scelta!',
            '🌟 Fantastico!',
            '⭐ Supporta il server!',
            '🎁 Il miglior investimento!',
            '💰 Ricevi bonus extra!'
        ];

        const existingMsg = element.querySelector('.encouragement-msg');
        if (existingMsg) return;

        const msg = document.createElement('div');
        msg.className = 'encouragement-msg';
        msg.textContent = messages[Math.floor(Math.random() * messages.length)];
        msg.style.position = 'absolute';
        msg.style.top = '-30px';
        msg.style.left = '50%';
        msg.style.transform = 'translateX(-50%)';
        msg.style.background = 'linear-gradient(135deg, var(--one-gold), #DAA520)';
        msg.style.color = 'black';
        msg.style.padding = '8px 16px';
        msg.style.borderRadius = '20px';
        msg.style.fontSize = '12px';
        msg.style.fontWeight = '900';
        msg.style.whiteSpace = 'nowrap';
        msg.style.zIndex = '1000';
        msg.style.boxShadow = '0 4px 15px rgba(255, 215, 0, 0.5)';
        msg.style.animation = 'slideInUp 0.3s ease-out, pulse 1s ease-in-out infinite';
        msg.style.pointerEvents = 'none';

        element.style.position = 'relative';
        element.appendChild(msg);

        setTimeout(() => {
            msg.style.animation = 'slideInUp 0.3s ease-out reverse';
            setTimeout(() => msg.remove(), 300);
        }, 2000);
    }

    // Auto-scroll smooth verso i pacchetti quando si clicca sul pulsante
    const donateButtons = document.querySelectorAll('a[href*="coins"]');
    donateButtons.forEach(btn => {
        btn.addEventListener('click', function(e) {
            const pricingSection = document.querySelector('.pricing-section');
            if (pricingSection && !this.getAttribute('href').includes('#')) {
                return; // Lascia che il link normale funzioni
            }
        });
    });

    // Effetto confetti quando si passa sui pacchetti popolari
    const popularPackages = document.querySelectorAll('.price-package.popular');
    popularPackages.forEach(pkg => {
        setInterval(() => {
            if (!pkg.matches(':hover')) {
                createMiniParticle(pkg);
            }
        }, 2000);
    });

    function createMiniParticle(element) {
        const particle = document.createElement('span');
        particle.textContent = '✨';
        particle.style.position = 'absolute';
        particle.style.fontSize = '12px';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.top = Math.random() * 100 + '%';
        particle.style.pointerEvents = 'none';
        particle.style.animation = 'particle-float 2s ease-out forwards';
        particle.style.zIndex = '10';

        element.appendChild(particle);
        setTimeout(() => particle.remove(), 2000);
    }

    // Highlight del contact badge quando lo vedi
    const contactBadges = document.querySelectorAll('.contact-badge');
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'pulse 2s ease-in-out infinite, glow 2s ease-in-out infinite';
            }
        });
    }, { threshold: 0.5 });

    contactBadges.forEach(badge => observer.observe(badge));

    // Effetto typing per il titolo
    const mainTitle = document.querySelector('.donation-header h2');
    if (mainTitle) {
        const originalText = mainTitle.textContent;
        mainTitle.textContent = '';
        let i = 0;

        setTimeout(() => {
            const typeInterval = setInterval(() => {
                if (i < originalText.length) {
                    mainTitle.textContent += originalText.charAt(i);
                    i++;
                } else {
                    clearInterval(typeInterval);
                }
            }, 50);
        }, 500);
    }

    console.log('🎉 Sistema donazioni caricato con successo!');
    console.log('💎 Animazioni attive per invogliare le donazioni!');
});
</script>
