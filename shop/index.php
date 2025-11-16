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
    
    <!-- Fonts - Ottimizzato per Performance -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600;700;900&family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        /* Font Display Strategy per Performance */
        @font-face {
            font-display: swap;
        }
    </style>
    
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

    <!-- Shop Ultimate CSS - Tutto unificato in un unico file -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/shop-ultimate.css" />
    <!-- Admin Panel CSS - Caricato solo per admin -->
    <?php if(is_loggedin() && web_admin_level()>=9) { ?>
    <link rel="stylesheet" href="<?php print $shop_url; ?>assets/css/admin-ultimate.css">
    <?php } ?>

    
    <!-- Favicon -->
    <link rel="shortcut icon" type="image/x-icon" href="<?php print $shop_url; ?>assets/img/logosito.png">
</head>

<body class="shop-one-body">
    <!-- Skip Link for Accessibility -->
    <a href="#main-content" class="skip-link" tabindex="1">Salta al contenuto principale</a>

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
                            <i class="fas fa-crown"></i> Bentornato, <strong><?php print safe_output(get_account_name()); ?></strong>
                        <?php } else { ?>
                            <i class="fas fa-store"></i> Benvenuto su ONE Premium Shop
                        <?php } ?>
                    </span>
                </div>
                <div class="top-right">
                    <!-- Language removed - Italian only -->
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
                        <span>Tutti gli Oggetti</span>
                    </a>
                    <?php if(is_loggedin() && is_paypal_list()) { ?>
                    <a href="<?php print $shop_url; ?>buy/coins" class="nav-item nav-special">
                        <i class="fas fa-hand-holding-usd"></i>
                        <span>Donazioni</span>
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
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
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
                                <span>Impostazioni Admin</span>
                            </a>
                            <a href="<?php print $shop_url; ?>admin/paypal" class="dropdown-item">
                                <i class="fas fa-hand-holding-usd"></i>
                                <span>Gestione Donazioni</span>
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
                    <span>Tutti gli Oggetti</span>
                </a>
                <?php if(is_loggedin() && is_paypal_list()) { ?>
                <a href="<?php print $shop_url; ?>buy/coins">
                    <i class="fas fa-hand-holding-usd"></i>
                    <span>Donazioni</span>
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
    <main class="shop-main" id="main-content">
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
                            <h3>Il Mio Portafoglio</h3>
                        </div>
                        <div class="card-body">
                            <?php if(is_paypal_list()) { ?>
                            <a href="<?php print $shop_url; ?>buy/coins" class="wallet-link">
                            <?php } ?>
                                <div class="wallet-item wallet-md">
                                    <div class="wallet-icon">
                                        <img src="<?php print $shop_url; ?>images/monet.png" alt="MD">
                                    </div>
                                    <div class="wallet-info">
                                        <span class="wallet-label">MD Coins</span>
                                        <span class="wallet-value"><?php print number_format(is_coins(), 0, '', ','); ?></span>
                                    </div>
                                </div>
                            <?php if(is_paypal_list()) { ?>
                            </a>
                            <a href="<?php print $shop_url; ?>buy/coins" class="btn-buy-coins">
                                <i class="fas fa-hand-holding-usd"></i>
                                <span>Dona Ora</span>
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
                            <h3>Dettagli Oggetto</h3>
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
                            <h3>Pannello Admin</h3>
                        </div>
                        <div class="card-body">
                            <a href="<?php print $shop_url; ?>settings" class="admin-link">
                                <i class="fas fa-cogs"></i>
                                <span>Impostazioni Shop</span>
                                <i class="fas fa-chevron-right"></i>
                            </a>
                            <a href="<?php print $shop_url; ?>admin/paypal" class="admin-link">
                                <i class="fas fa-hand-holding-usd"></i>
                                <span>Gestione Donazioni</span>
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
                            <h3>Acquisti Recenti</h3>
                        </div>
                        <div class="card-body">
                            <?php include 'include/sidebar/last_bought.php'; ?>
                        </div>
                    </div>
                    <?php } ?>

                    <!-- Top Selling Products -->
                    <div class="sidebar-card stats-card">
                        <div class="card-header">
                            <i class="fas fa-fire"></i>
                            <h3>Più Venduti</h3>
                        </div>
                        <div class="card-body">
                            <?php
                            $top_items = get_top_selling_items(5);
                            if(empty($top_items)) {
                                echo '<div class="widget-empty-state">
                                        <i class="fas fa-shopping-bag"></i>
                                        <p>Nessuna vendita ancora</p>
                                      </div>';
                            } else {
                                echo '<div class="top-items-list">';
                                $rank = 1;
                                foreach($top_items as $item) {
                                    $item_name = !$item_name_db ? get_item_name($item['vnum']) : get_item_name_locale_name($item['vnum']);
                                    $medal = $rank == 1 ? '🥇' : ($rank == 2 ? '🥈' : ($rank == 3 ? '🥉' : $rank));
                                    echo '<a href="'.$shop_url.'item/'.$item['id'].'/" class="top-item">
                                            <div class="top-item-rank">'.$medal.'</div>
                                            <div class="top-item-image">
                                                <img src="'.$shop_url.'images/items/'.get_item_image($item['vnum'], $item['id']).'.png" alt="'.$item_name.'">
                                            </div>
                                            <div class="top-item-info">
                                                <div class="top-item-name">'.htmlspecialchars($item_name).'</div>
                                                <div class="top-item-sales">
                                                    <i class="fas fa-shopping-cart"></i>
                                                    <span>'.number_format($item['total_sales']).' vendite</span>
                                                </div>
                                            </div>
                                          </a>';
                                    $rank++;
                                }
                                echo '</div>';
                            }
                            ?>
                        </div>
                    </div>

                    <!-- Top Donors -->
                    <?php if(is_loggedin()) { ?>
                    <div class="sidebar-card stats-card">
                        <div class="card-header">
                            <i class="fas fa-trophy"></i>
                            <h3>Top Donatori</h3>
                        </div>
                        <div class="card-body">
                            <?php
                            // Leggi top donatori da file TXT (consenso esplicito)
                            $top_donors = [];
                            $donor_file = __DIR__ . '/data/top_donatori.txt';
                            if(file_exists($donor_file)) {
                                $lines = file($donor_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
                                foreach($lines as $line) {
                                    $line = trim($line);
                                    if(empty($line) || $line[0] == '#') continue; // Salta commenti

                                    $parts = explode('|', $line);
                                    if(count($parts) == 3) {
                                        $top_donors[] = [
                                            'buyer' => $parts[0],
                                            'total_spent' => intval($parts[1]),
                                            'total_purchases' => intval($parts[2])
                                        ];
                                    }
                                }
                            }

                            if(empty($top_donors)) {
                                echo '<div class="widget-empty-state">
                                        <i class="fas fa-users"></i>
                                        <p>Nessun donatore ancora</p>
                                      </div>';
                            } else {
                                echo '<div class="top-donors-list">';
                                $rank = 1;
                                foreach($top_donors as $donor) {
                                    if($rank > 3) break; // Mostra solo top 3
                                    $medal = $rank == 1 ? '👑' : ($rank == 2 ? '🥈' : '🥉');
                                    $crown_class = $rank == 1 ? 'top-donor-gold' : ($rank == 2 ? 'top-donor-silver' : 'top-donor-bronze');
                                    echo '<div class="top-donor '.$crown_class.'">
                                            <div class="top-donor-rank">'.$medal.'</div>
                                            <div class="top-donor-info">
                                                <div class="top-donor-name">'.htmlspecialchars($donor['buyer']).'</div>
                                                <div class="top-donor-stats">
                                                    <span class="donor-spent">
                                                        <img src="'.$shop_url.'images/monet.png" style="width: 16px; height: 16px;">
                                                        '.number_format($donor['total_spent']).' MD
                                                    </span>
                                                    <span class="donor-purchases">
                                                        <i class="fas fa-shopping-bag"></i>
                                                        '.number_format($donor['total_purchases']).' acquisti
                                                    </span>
                                                </div>
                                            </div>
                                          </div>';
                                    $rank++;
                                }
                                echo '</div>';
                            }
                            ?>
                        </div>
                    </div>
                    <?php } ?>

                    <!-- Shop Statistics - SOLO ADMIN -->
                    <?php if(is_loggedin() && web_admin_level()>=9) { ?>
                    <div class="sidebar-card stats-card">
                        <div class="card-header">
                            <i class="fas fa-chart-bar"></i>
                            <h3>Statistiche Shop</h3>
                            <span style="background: var(--one-scarlet); padding: 2px 8px; border-radius: 4px; font-size: 10px; margin-left: auto;">ADMIN</span>
                        </div>
                        <div class="card-body">
                            <?php
                            $stats = get_shop_statistics();
                            echo '<div class="shop-stats-grid">
                                    <div class="stat-item">
                                        <div class="stat-icon"><i class="fas fa-box"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-value">'.number_format($stats['total_items']).'</div>
                                            <div class="stat-label">Prodotti</div>
                                        </div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-icon"><i class="fas fa-th-large"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-value">'.number_format($stats['total_categories']).'</div>
                                            <div class="stat-label">Categorie</div>
                                        </div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-icon"><i class="fas fa-shopping-cart"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-value">'.number_format($stats['total_sales']).'</div>
                                            <div class="stat-label">Vendite</div>
                                        </div>
                                    </div>
                                    <div class="stat-item">
                                        <div class="stat-icon"><i class="fas fa-users"></i></div>
                                        <div class="stat-info">
                                            <div class="stat-value">'.number_format($stats['total_users']).'</div>
                                            <div class="stat-label">Clienti</div>
                                        </div>
                                    </div>
                                  </div>';
                            ?>
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
                        case 'edit_item':
                            include 'pages/admin/edit_item.php';
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
                                <h3>Accesso Rapido</h3>
                                <p>Effettua il login per accedere al tuo account e allo shop</p>
                            </div>
                            <form action="<?php print $shop_url; ?>login" method="post" class="quick-login-form">
                                <?php echo csrf_field(); ?>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label>
                                            <i class="fas fa-user"></i>
                                            Nome Utente
                                        </label>
                                        <input
                                            type="text"
                                            name="username"
                                            pattern="[a-zA-Z0-9_]{5,64}"
                                            maxlength="64"
                                            placeholder="Inserisci il tuo username"
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
                                            placeholder="Inserisci la tua password"
                                            required
                                        >
                                    </div>
                                </div>
                                <button type="submit" class="btn-submit-login">
                                    <i class="fas fa-sign-in-alt"></i>
                                    <span>Accedi Ora</span>
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
                        <a href="#">Termini di Servizio</a>
                        <a href="#">Privacy Policy</a>
                        <a href="#">Supporto</a>
                    </div>
                </div>
            </div>
        </div>
    </footer>

<!-- Shop Ultimate JavaScript - Tutto unificato in un unico file -->
<script src="<?php print $shop_url; ?>assets/js/shop-ultimate.js"></script>
<?php if(file_exists('include/functions/js.php')) include 'include/functions/js.php'; ?>
</body>
</html>