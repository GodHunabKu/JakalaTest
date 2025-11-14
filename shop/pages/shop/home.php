<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="admin-actions-bar">
    <a href="<?php print $shop_url; ?>categories" class="btn-admin btn-admin-primary">
        <i class="fas fa-cog"></i>
        <span><?php print $lang_shop['administration_categories']; ?></span>
    </a>
    <a href="<?php print $shop_url; ?>admin/paypal" class="btn-admin btn-admin-success">
        <i class="fab fa-paypal"></i>
        <span><?php print $lang_shop['administration_pp']; ?></span>
    </a>
</div>
<?php } ?>

<?php if(!is_loggedin()) { ?>
<!-- ====================================
     SCHERMATA LOGIN FULL SCREEN
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
            <p class="login-description">Accedi per esplorare il negozio e acquistare oggetti esclusivi</p>
        </div>

        <!-- Form Login -->
        <div class="fullscreen-login-card">
            <?php
            if(isset($_POST['username'], $_POST['password'])) {
                if(login($_POST['username'], $_POST['password'], 1)) {
                    echo '<div class="alert-message alert-success">
                            <i class="fas fa-check-circle"></i>
                            <span>'.$lang_shop['login_success'].'</span>
                          </div>';
                    echo '<script>setTimeout(function(){ window.location.reload(); }, 1000);</script>';
                } else {
                    echo '<div class="alert-message alert-error">
                            <i class="fas fa-exclamation-circle"></i>
                            <span>'.$lang_shop['login_fail'].'</span>
                          </div>';
                }
            }
            ?>

            <form action="" method="post" class="fullscreen-login-form">
                <div class="form-group-fullscreen">
                    <label>
                        <i class="fas fa-user"></i>
                        <?php print $lang_shop['name_login']; ?>
                    </label>
                    <input 
                        type="text" 
                        name="username" 
                        id="username" 
                        pattern=".{5,64}" 
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

<?php } else { ?>
<!-- ====================================
     CONTENUTO NORMALE (LOGGATO)
     ==================================== -->
<div class="shop-content-wrapper">
    <!-- Page Header -->
    <div class="page-header">
        <div class="page-title">
            <i class="fas fa-store"></i>
            <h1><?php print $lang_shop['site_title']; ?></h1>
        </div>
        <div class="page-breadcrumb">
            <a href="<?php print $shop_url; ?>">Home</a>
        </div>
    </div>

    <!-- Categories Grid -->
    <div class="categories-grid">
        <?php
        $list = array();
        $list = is_categories_list();
        
        if(!count($list)) {
            echo '<div class="empty-state">
                    <i class="fas fa-box-open"></i>
                    <h3>No categories available</h3>
                    <p>Check back soon for new items!</p>
                  </div>';
        } else {
            foreach($list as $row) {
        ?>
        <a href="<?php print $shop_url.'category/'.$row['id'].'/'; ?>" class="category-card">
            <div class="category-card-inner">
                <div class="category-image">
                    <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['img']); ?>.png" alt="<?php print $row['name']; ?>">
                    <div class="category-overlay"></div>
                </div>
                <?php if(checkForPromotions($row['id'])) { ?>
                <div class="category-badge">
                    <i class="fas fa-fire"></i>
                    <span><?php print $lang_shop['promotion']; ?></span>
                </div>
                <?php } ?>
                <div class="category-content">
                    <h3 class="category-name"><?php print $row['name']; ?></h3>
                    <div class="category-action">
                        <span>View Items</span>
                        <i class="fas fa-arrow-right"></i>
                    </div>
                </div>
            </div>
        </a>
        <?php } } ?>
    </div>
</div>
<?php } ?>