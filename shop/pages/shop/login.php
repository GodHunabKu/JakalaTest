<!-- ====================================
     LOGIN PAGE - FULLSCREEN STYLE
     ==================================== -->
<div class="fullscreen-login-wrapper">
    <div class="login-background-animated">
        <div class="bg-gradient-animated"></div>
        <div class="particles-animated"></div>
    </div>
    
    <div class="fullscreen-login-container">
        <!-- Logo e Titolo -->
        <div class="fullscreen-login-header">
            <div class="login-logo-large">
                <img src="<?php print $shop_url; ?>images/logo3.png" alt="ONE Shop">
            </div>
            <h1 class="login-title-large">ONE SHOP</h1>
            <p class="login-subtitle-large">ULTIMATE EDITION</p>
            <div class="login-divider"></div>
            <p class="login-description">Accedi al tuo account per continuare</p>
        </div>

        <!-- Form Login -->
        <div class="fullscreen-login-card">
            <?php
            if(isset($_POST['username'], $_POST['password'])) {
                // CSRF Protection
                if(CSRF_PROTECTION && !csrf_verify()) {
                    echo '<div class="alert-message alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>Security token validation failed. Please try again.</span>
                          </div>';
                } else if(login($_POST['username'], $_POST['password'], 1)) {
                    echo '<div class="alert-message alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span>'.$lang_shop['login_success'].'</span>
                          </div>';
                    echo '<script>setTimeout(function(){ window.location.href = "'.$shop_url.'"; }, 1500);</script>';
                } else {
                    echo '<div class="alert-message alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>'.$lang_shop['login_fail'].'</span>
                          </div>';
                }
            }
            ?>

            <form action="" method="post" class="fullscreen-login-form">
                <?php echo csrf_field(); ?>
                <div class="form-group-fullscreen">
                    <label>
                        <i class="fas fa-user"></i>
                        <?php print $lang_shop['name_login']; ?>
                    </label>
                    <input
                        type="text"
                        name="username"
                        id="username"
                        pattern="[a-zA-Z0-9_]{5,64}"
                        maxlength="64"
                        placeholder="<?php print $lang_shop['name_login']; ?>"
                        required
                        autocomplete="off"
                        class="input-fullscreen"
                    >
                </div>

                <div class="form-group-fullscreen">
                    <label>
                        <i class="fas fa-lock"></i>
                        <?php print $lang_shop['password']; ?>
                    </label>
                    <input 
                        type="password" 
                        name="password" 
                        id="password" 
                        pattern=".{5,16}" 
                        maxlength="16" 
                        placeholder="<?php print $lang_shop['password']; ?>" 
                        required
                        class="input-fullscreen"
                    >
                </div>

                <button type="submit" name="login" class="btn-login-fullscreen">
                    <span class="btn-content">
                        <i class="fas fa-sign-in-alt"></i>
                        <span><?php print $lang_shop['login']; ?></span>
                    </span>
                    <div class="btn-glow-effect"></div>
                </button>
            </form>

            <!-- Link Back to Home -->
            <div class="login-back-link">
                <a href="<?php print $shop_url; ?>">
                    <i class="fas fa-arrow-left"></i>
                    <span>Torna alla Home</span>
                </a>
            </div>
        </div>

        <!-- Footer Info -->
        <div class="fullscreen-login-footer">
            <div class="login-features">
                <div class="feature-item">
                    <i class="fas fa-shield-alt"></i>
                    <span>Sicuro</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-bolt"></i>
                    <span>Veloce</span>
                </div>
                <div class="feature-item">
                    <i class="fas fa-gem"></i>
                    <span>Premium</span>
                </div>
            </div>
        </div>
    </div>
</div>