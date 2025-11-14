<?php
@ob_start();
include 'include/functions/header.php';
?>
<!DOCTYPE html>
<html lang="<?php print $language_code; ?>">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <title><?php print $lang_shop['site_title'].' - '.$server_name; ?></title>
    
    <!-- Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    
    <!-- Shop ONE CSS - Unificato e Ottimizzato -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/shop-one.css" />
    
    <!-- Favicon -->
    <link rel="shortcut icon" type="image/x-icon" href="<?php print $shop_url; ?>assets/img/logosito.png">
</head>

<body class="shop-one-body">
    <!-- Animated Background -->
    <div class="animated-bg">
        <div class="bg-gradient"></div>
        <div class="particles"></div>
    </div>

    <!-- Top Bar -->
    <div class="top-bar">
        <div class="container-fluid">
            <div class="top-bar-content">
                <div class="top-left">
                    <span class="welcome-text">
                        <?php if(is_loggedin()) { ?>
                            <i class="fas fa-crown"></i> Welcome back, <strong><?php print safe_output(get_account_name()); ?></strong>
                        <?php } else { ?>
                            <i class="fas fa-store"></i> Welcome to ONE Premium Shop
                        <?php } ?>
                    </span>
                </div>
                <div class="top-right">
                    <!-- Language Selector -->
                    <div class="language-selector">
                        <button class="lang-btn">
                            <i class="fas fa-globe"></i>
                            <span><?php print $language_codes[$language_code]; ?></span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="lang-dropdown">
                            <?php foreach($language_codes as $key => $value) { ?>
                            <a href="<?php print $shop_url; ?>?lang=<?php print $key; ?>" class="lang-item">
                                <img src="<?php print $shop_url; ?>assets/img/language/<?php print $key; ?>.png" alt="<?php print $value; ?>">
                                <span><?php print $value; ?></span>
                            </a>
                            <?php } ?>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Header -->
    <header class="shop-header">
        <div class="container-fluid">
            <div class="header-content">
                <!-- Logo -->
                <a href="<?php print $shop_url; ?>" class="brand-logo">
                    <img src="<?php print $shop_url; ?>images/logo3.png" alt="ONE Shop">
                    <div class="logo-text">
                        <span class="main-title">ONE</span>
                        <span class="sub-title">Premium Shop</span>
                    </div>
                </a>

                <!-- Main Navigation -->
                <nav class="main-nav">
                    <a href="<?php print $shop_url; ?>" class="nav-item <?php if($current_page=='home') print 'active'; ?>">
                        <i class="fas fa-home"></i>
                        <span>Home</span>
                    </a>
                    <a href="<?php print $shop_url; ?>items" class="nav-item <?php if($current_page=='items') print 'active'; ?>">
                        <i class="fas fa-shopping-bag"></i>
                        <span>All Items</span>
                    </a>
                    <?php if(is_loggedin() && is_paypal_list()) { ?>
                    <a href="<?php print $shop_url; ?>buy/coins" class="nav-item nav-special">
                        <i class="fas fa-coins"></i>
                        <span>Buy Coins</span>
                        <div class="nav-glow"></div>
                    </a>
                    <?php } ?>
                </nav>

                <!-- User Actions -->
                <div class="header-actions">
                    <?php if(!is_loggedin()) { ?>
                    <a href="<?php print $shop_url; ?>login" class="btn-header btn-login">
                        <i class="fas fa-sign-in-alt"></i>
                        <span>Login</span>
                    </a>
                    <?php } else { ?>
                    <!-- Coins Display - Solo MD -->
                    <div class="coins-display">
                        <div class="coin-item coin-md">
                            <img src="<?php print $shop_url; ?>images/md2.png" alt="MD">
                            <span class="coin-amount"><?php print number_format(is_coins(), 0, '', ','); ?></span>
                        </div>
                    </div>
                    
                    <!-- User Menu -->
                    <div class="user-menu">
                        <button class="user-btn">
                            <i class="fas fa-user-circle"></i>
                            <span class="user-name"><?php print safe_output(get_account_name()); ?></span>
                            <i class="fas fa-chevron-down"></i>
                        </button>
                        <div class="user-dropdown">
                            <?php if(web_admin_level()>=9) { ?>
                            <a href="<?php print $shop_url; ?>settings" class="dropdown-item">
                                <i class="fas fa-cogs"></i>
                                <span>Admin Settings</span>
                            </a>
                            <a href="<?php print $shop_url; ?>admin/paypal" class="dropdown-item">
                                <i class="fab fa-paypal"></i>
                                <span>PayPal Manager</span>
                            </a>
                            <div class="dropdown-divider"></div>
                            <?php } ?>
                            <a href="<?php print $shop_url; ?>logout" class="dropdown-item logout">
                                <i class="fas fa-sign-out-alt"></i>
                                <span>Logout</span>
                            </a>
                        </div>
                    </div>
                    <?php } ?>
                </div>

                <!-- Mobile Menu Toggle -->
                <button class="mobile-toggle" id="mobileMenuToggle">
                    <span></span>
                    <span></span>
                    <span></span>
                </button>
            </div>
        </div>
    </header>

    <!-- Mobile Menu -->
    <div class="mobile-menu" id="mobileMenu">
        <div class="mobile-menu-content">
            <nav class="mobile-nav">
                <a href="<?php print $shop_url; ?>">
                    <i class="fas fa-home"></i>
                    <span>Home</span>
                </a>
                <a href="<?php print $shop_url; ?>items">
                    <i class="fas fa-shopping-bag"></i>
                    <span>All Items</span>
                </a>
                <?php if(is_loggedin() && is_paypal_list()) { ?>
                <a href="<?php print $shop_url; ?>buy/coins">
                    <i class="fas fa-coins"></i>
                    <span>Buy Coins</span>
                </a>
                <?php } ?>
                <?php if(!is_loggedin()) { ?>
                <a href="<?php print $shop_url; ?>login">
                    <i class="fas fa-sign-in-alt"></i>
                    <span>Login</span>
                </a>
                <?php } else { ?>
                <a href="<?php print $shop_url; ?>logout">
                    <i class="fas fa-sign-out-alt"></i>
                    <span>Logout</span>
                </a>
                <?php } ?>
            </nav>
        </div>
    </div>

    <!-- Main Content -->
    <main class="shop-main">
        <div class="container-fluid">
            <div class="main-layout">
                <!-- Sidebar -->
                <?php if(is_loggedin() || $current_page=='item') { ?>
                <aside class="shop-sidebar">
                    <!-- Coins Card (Mobile) -->
                    <?php if(is_loggedin()) { ?>
                    <div class="sidebar-card coins-card">
                        <div class="card-header">
                            <i class="fas fa-wallet"></i>
                            <h3>My Wallet</h3>
                        </div>
                        <div class="card-body">
                            <?php if(is_paypal_list()) { ?>
                            <a href="<?php print $shop_url; ?>buy/coins" class="wallet-link">
                            <?php } ?>
                                <div class="wallet-item wallet-md">
                                    <div class="wallet-icon">
                                        <img src="<?php print $shop_url; ?>images/md2.png" alt="MD">
                                    </div>
                                    <div class="wallet-info">
                                        <span class="wallet-label">MD Coins</span>
                                        <span class="wallet-value"><?php print number_format(is_coins(), 0, '', ','); ?></span>
                                    </div>
                                </div>
                            <?php if(is_paypal_list()) { ?>
                            </a>
                            <a href="<?php print $shop_url; ?>buy/coins" class="btn-buy-coins">
                                <i class="fas fa-plus-circle"></i>
                                <span>Add Coins</span>
                            </a>
                            <?php } ?>
                        </div>
                    </div>
                    <?php } ?>

                    <!-- Item Info Sidebar (se nella pagina item) -->
                    <?php if($current_page=='item') { ?>
                    <div class="sidebar-card">
                        <div class="card-header">
                            <i class="fas fa-info-circle"></i>
                            <h3>Item Details</h3>
                        </div>
                        <div class="card-body">
                            <?php include 'include/sidebar/info_object.php'; ?>
                        </div>
                    </div>
                    <?php } ?>

                    <!-- Admin Card -->
                    <?php if(is_loggedin() && web_admin_level()>=9) { ?>
                    <div class="sidebar-card admin-card">
                        <div class="card-header">
                            <i class="fas fa-shield-alt"></i>
                            <h3>Admin Panel</h3>
                        </div>
                        <div class="card-body">
                            <a href="<?php print $shop_url; ?>settings" class="admin-link">
                                <i class="fas fa-cogs"></i>
                                <span>Shop Settings</span>
                                <i class="fas fa-chevron-right"></i>
                            </a>
                            <a href="<?php print $shop_url; ?>admin/paypal" class="admin-link">
                                <i class="fab fa-paypal"></i>
                                <span>PayPal Manager</span>
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </div>
                    </div>
                    <?php } ?>

                    <!-- Last Bought -->
                    <?php if(is_loggedin()) { ?>
                    <div class="sidebar-card">
                        <div class="card-header">
                            <i class="fas fa-history"></i>
                            <h3>Recent Purchases</h3>
                        </div>
                        <div class="card-body">
                            <?php include 'include/sidebar/last_bought.php'; ?>
                        </div>
                    </div>
                    <?php } ?>
                </aside>
                <?php } ?>

                <!-- Main Content Area -->
                <div class="content-area <?php if(!is_loggedin() && $current_page!='item') print 'content-full'; ?>">
                    <?php
                    switch ($current_page) {
                        case 'home':
                            include 'pages/shop/home.php';
                            break;
                        case 'items':
                            include 'pages/shop/items.php';
                            break;
                        case 'item':
                            include 'pages/shop/item.php';
                            break;
                        case 'login':
                            include 'pages/shop/login.php';
                            break;
                        case 'logout':
                            include 'pages/shop/logout.php';
                            break;
                        case 'categories':
                            include 'pages/admin/is_categories.php';
                            break;
                        case 'add_items':
                            include 'pages/admin/add_items.php';
                            break;
                        case 'add_items_bonus':
                            include 'pages/admin/add_items_bonus.php';
                            break;
                        case 'settings':
                            include 'pages/admin/settings.php';
                            break;
                        case 'paypal':
                            include 'pages/admin/paypal.php';
                            break;
                        case 'coins':
                            include 'pages/shop/coins.php';
                            break;
                        case 'pay':
                            include 'pages/shop/pay.php';
                            break;
                        default:
                            include 'pages/shop/home.php';
                    }
                    
                    // Quick Login (se non loggato)
                    if(!is_loggedin() && $current_page!='login') {
                    ?>
                    <div class="quick-login-section">
                        <div class="quick-login-card">
                            <div class="login-header">
                                <i class="fas fa-lock"></i>
                                <h3>Quick Access</h3>
                                <p>Login to access your account and shop</p>
                            </div>
                            <form action="<?php print $shop_url; ?>login" method="post" class="quick-login-form">
                                <?php echo csrf_field(); ?>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>
                                            <i class="fas fa-user"></i>
                                            Username
                                        </label>
                                        <input
                                            type="text"
                                            name="username"
                                            pattern="[a-zA-Z0-9_]{5,64}"
                                            maxlength="64"
                                            placeholder="Enter your username"
                                            required
                                            autocomplete="off"
                                        >
                                    </div>
                                    <div class="form-group">
                                        <label>
                                            <i class="fas fa-lock"></i>
                                            Password
                                        </label>
                                        <input 
                                            type="password" 
                                            name="password" 
                                            pattern=".{5,16}" 
                                            maxlength="16" 
                                            placeholder="Enter your password" 
                                            required
                                        >
                                    </div>
                                </div>
                                <button type="submit" class="btn-submit-login">
                                    <i class="fas fa-sign-in-alt"></i>
                                    <span>Login Now</span>
                                    <div class="btn-glow"></div>
                                </button>
                            </form>
                        </div>
                    </div>
                    <?php } ?>
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="shop-footer">
        <div class="container-fluid">
            <div class="footer-content">
                <div class="footer-left">
                    <img src="<?php print $shop_url; ?>images/logo3.png" alt="ONE" class="footer-logo">
                    <p>&copy; <?php 
                        $year = date('Y');
                        if($year > 2017) print '2017 - '.$year;
                        else print $year;
                    ?> <?php print $server_name; ?>. All rights reserved.</p>
                </div>
                <div class="footer-right">
                    <div class="footer-links">
                        <a href="#">Terms of Service</a>
                        <a href="#">Privacy Policy</a>
                        <a href="#">Support</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

<!-- Shop ONE JavaScript - Unificato e Ottimizzato -->
<script src="<?php print $shop_url; ?>assets/js/shop-one.js"></script>
<?php if(file_exists('include/functions/js.php')) include 'include/functions/js.php'; ?>
</body>
</html>