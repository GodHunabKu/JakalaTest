<?php
// Effettua il logout
logout_shop();
?>

<!-- ====================================
     LOGOUT PAGE - CONFIRMATION SCREEN
     ==================================== -->
<div class="fullscreen-logout-wrapper">
    <div class="logout-background-animated">
        <div class="bg-gradient-animated"></div>
        <div class="particles-animated"></div>
    </div>
    
    <div class="logout-confirmation-container">
        <!-- Logo e Animazione -->
        <div class="logout-icon-wrapper">
            <div class="logout-icon-circle">
                <i class="fas fa-sign-out-alt"></i>
            </div>
            <div class="logout-icon-glow"></div>
        </div>

        <!-- Messaggio -->
        <div class="logout-message">
            <h1 class="logout-title">Logout Effettuato</h1>
            <p class="logout-subtitle">Grazie per aver visitato ONE Shop</p>
            <div class="logout-divider"></div>
            <p class="logout-description">Verrai reindirizzato alla home tra pochi secondi...</p>
        </div>

        <!-- Progress Bar -->
        <div class="logout-progress-wrapper">
            <div class="logout-progress-bar">
                <div class="logout-progress-fill"></div>
            </div>
            <p class="logout-progress-text">
                <i class="fas fa-spinner fa-spin"></i>
                Reindirizzamento in corso...
            </p>
        </div>

        <!-- Action Buttons -->
        <div class="logout-actions">
            <a href="<?php print $shop_url; ?>" class="btn-logout-home">
                <i class="fas fa-home"></i>
                <span>Vai alla Home</span>
            </a>
            <a href="<?php print $shop_url; ?>login" class="btn-logout-login">
                <i class="fas fa-sign-in-alt"></i>
                <span>Accedi Nuovamente</span>
            </a>
        </div>
    </div>
</div>

<!-- Auto Redirect Script -->
<script>
// Redirect automatico dopo 3 secondi
setTimeout(function() {
    window.location.href = '<?php print $shop_url; ?>';
}, 3000);
</script>