<!-- Donazioni Page - Scarlet Warlord Edition (Definitive) -->
<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="admin-toolbar mb-4 text-right">
    <a href="<?php print $shop_url.'admin/paypal'; ?>" class="btn btn-info">
        <i class="fa fa-cog"></i> Gestione Donazioni
    </a>
</div>
<?php } ?>

<div class="donations-page-wrapper">
    
    <!-- Hero Header -->
    <div class="donations-hero text-center mb-5">
        <div class="hero-logo-wrapper">
            <img src="<?php print $shop_url; ?>images/logo.png" alt="Server Logo" class="server-logo-hero">
        </div>
        <h1 class="hero-title">Supporta il Server</h1>
        <p class="hero-subtitle">Ottieni Monete del Drago (MD) e domina il gioco.<br>Il tuo supporto è la nostra forza.</p>
    </div>

    <!-- Metodi di Pagamento -->
    <div class="section-header text-center mb-5">
        <h2 class="section-title-large"><i class="fa fa-credit-card"></i> Metodi Accettati</h2>
    </div>

    <div class="payment-methods-grid row justify-content-center mb-5">
        <div class="col-md-3 col-6 mb-3">
            <div class="payment-method-card">
                <i class="fa fa-paypal"></i>
                <h3>PayPal</h3>
            </div>
        </div>
        <div class="col-md-3 col-6 mb-3">
            <div class="payment-method-card">
                <i class="fa fa-credit-card"></i>
                <h3>Postepay</h3>
            </div>
        </div>
        <div class="col-md-3 col-6 mb-3">
            <div class="payment-method-card">
                <i class="fa fa-university"></i>
                <h3>Bonifico</h3>
            </div>
        </div>
        <div class="col-md-3 col-6 mb-3">
            <div class="payment-method-card">
                <i class="fa fa-exchange"></i>
                <h3>Revolut</h3>
            </div>
        </div>
    </div>

    <!-- Pacchetti MD Coins -->
    <div class="section-header text-center mb-5">
        <h2 class="section-title-large"><i class="fa fa-coins"></i> Scegli il tuo Destino</h2>
        <p class="text-muted">Pacchetti esclusivi per guerrieri leggendari</p>
    </div>

    <div class="row pricing-container justify-content-center">
        <!-- Starter -->
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="coin-package-card package-starter">
                <div class="package-header">
                    <h3 class="package-title">Starter Pack</h3>
                    <div class="coin-amount">125</div>
                    <div class="coin-label">MD Coins</div>
                </div>
                <div class="package-body">
                    <div class="bonus-row">
                        <span class="text-muted">Nessun Bonus</span>
                    </div>
                    <div class="package-price">5€</div>
                    <a href="#how-to-donate" class="btn btn-donate btn-block">Scegli</a>
                </div>
            </div>
        </div>

        <!-- Base -->
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="coin-package-card package-adventurer">
                <div class="package-header">
                    <h3 class="package-title">Adventurer</h3>
                    <div class="coin-amount">250</div>
                    <div class="coin-label">MD Coins</div>
                </div>
                <div class="package-body">
                    <div class="bonus-row">
                        <span class="text-muted">Nessun Bonus</span>
                    </div>
                    <div class="package-price">10€</div>
                    <a href="#how-to-donate" class="btn btn-donate btn-block">Scegli</a>
                </div>
            </div>
        </div>

        <!-- Premium -->
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="coin-package-card package-warrior">
                <div class="package-header">
                    <h3 class="package-title">Warrior</h3>
                    <div class="coin-amount">750</div>
                    <div class="coin-label">MD Coins</div>
                </div>
                <div class="package-body">
                    <div class="bonus-row">
                        <span class="text-muted">Nessun Bonus</span>
                    </div>
                    <div class="package-price">30€</div>
                    <a href="#how-to-donate" class="btn btn-donate btn-block">Scegli</a>
                </div>
            </div>
        </div>

        <!-- Gold (Featured) -->
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="coin-package-card featured package-gold">
                <div class="best-value-badge">POPOLARE</div>
                <div class="package-header">
                    <h3 class="package-title">Gold Warlord</h3>
                    <div class="coin-amount">1,312</div>
                    <div class="coin-label">MD Coins</div>
                </div>
                <div class="package-body">
                    <div class="bonus-row">
                        <span class="bonus-badge">+5% BONUS</span>
                        <span class="text-warning">+62 MD</span>
                    </div>
                    <div class="package-price">50€</div>
                    <a href="#how-to-donate" class="btn btn-donate btn-block">Scegli</a>
                </div>
            </div>
        </div>

        <!-- Platinum (Featured) -->
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="coin-package-card featured package-platinum">
                <div class="best-value-badge">BEST VALUE</div>
                <div class="package-header">
                    <h3 class="package-title">Platinum King</h3>
                    <div class="coin-amount">4,125</div>
                    <div class="coin-label">MD Coins</div>
                </div>
                <div class="package-body">
                    <div class="bonus-row">
                        <span class="bonus-badge">+10% BONUS</span>
                        <span class="text-warning">+375 MD</span>
                    </div>
                    <div class="package-price">150€</div>
                    <a href="#how-to-donate" class="btn btn-donate btn-block">Scegli</a>
                </div>
            </div>
        </div>

        <!-- Diamond (Featured) -->
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="coin-package-card featured package-diamond">
                <div class="best-value-badge">LEGENDARY</div>
                <div class="package-header">
                    <h3 class="package-title">Diamond God</h3>
                    <div class="coin-amount">9,000</div>
                    <div class="coin-label">MD Coins</div>
                </div>
                <div class="package-body">
                    <div class="bonus-row">
                        <span class="bonus-badge">+20% BONUS</span>
                        <span class="text-warning">+1,500 MD</span>
                    </div>
                    <div class="package-price">300€</div>
                    <a href="#how-to-donate" class="btn btn-donate btn-block">Scegli</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Come Donare Steps -->
    <div id="how-to-donate" class="section-header text-center mt-5 mb-5">
        <h2 class="section-title-large"><i class="fa fa-list-ol"></i> Procedura di Donazione</h2>
    </div>

    <div class="donation-steps-modern row">
        <div class="col-md-3 mb-3">
            <div class="step-card">
                <div class="step-number">1</div>
                <h3 class="step-title">Contatta</h3>
                <p class="step-desc">Scrivi a <strong>[GF]BigSmoke</strong> su Discord.</p>
                <a href="#" class="btn btn-sm btn-outline-danger mt-3"><i class="fa fa-discord"></i> Discord</a>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="step-card">
                <div class="step-number">2</div>
                <h3 class="step-title">Scegli</h3>
                <p class="step-desc">Indica il pacchetto desiderato.</p>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="step-card">
                <div class="step-number">3</div>
                <h3 class="step-title">Paga</h3>
                <p class="step-desc">Invia il pagamento e la ricevuta.</p>
            </div>
        </div>
        <div class="col-md-3 mb-3">
            <div class="step-card">
                <div class="step-number">4</div>
                <h3 class="step-title">Ricevi</h3>
                <p class="step-desc">Goditi i tuoi MD Coins in gioco!</p>
            </div>
        </div>
    </div>

    <!-- Note Importanti -->
    <div class="alert alert-warning mt-5" style="background: rgba(255, 0, 0, 0.1); border: 1px solid #ff0000; color: #ffcccc;">
        <h4 class="alert-heading"><i class="fa fa-exclamation-triangle"></i> Note Importanti</h4>
        <p class="mb-0">
            Le donazioni sono volontarie e finalizzate al mantenimento del server. Una volta effettuata la donazione e ricevuti i Coins, non è possibile richiedere il rimborso.
            In caso di problemi, contatta immediatamente lo staff.
        </p>
    </div>

</div>