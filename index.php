<?php
	@ob_start();
	include 'include/functions/header.php';
?>
<!DOCTYPE html>
<html>

<head>
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	
    <title><?php print $lang_shop['site_title'].' - '.$server_name; ?></title>
	
    <!-- Preconnect per Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    
    <!-- Google Fonts - Inter e Cinzel -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&family=Cinzel:wght@600;700&display=swap" rel="stylesheet">
    
    <!-- CSS Base e Bootstrap -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/base.css" />
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/fonts.css" />
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/bootstrap.css" />
    
    <!-- CSS Nuovo Design Ultra Fedele -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/master3.css?v=<?php echo time(); ?>" />
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/shop-items-enhanced2.css?v=<?php echo time(); ?>" />
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/shop-features-2025.css?v=<?php echo time(); ?>" />


    <!-- SCARLET WARLORD THEME (DEFINITIVE 10/10) -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/scarlet-theme.css?v=<?php echo time(); ?>" />

    <!-- CSS ULTRA-OPTIMIZED GASATO 🔥 -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/shop-ultra-optimized.css?v=<?php echo time(); ?>" />

    <!-- Font Awesome e Animazioni -->
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/font-awesome.min.css" />
    <link rel="stylesheet" type="text/css" href="<?php print $shop_url; ?>assets/css/animate.css" />
    <link rel="stylesheet" href="<?php print $shop_url; ?>assets/css/hero-section.css?v=<?php echo time(); ?>">
    <link rel="stylesheet" href="<?php print $shop_url; ?>assets/css/item-cards-rarity.css?v=<?php echo time(); ?>">


    <link rel="shortcut icon" type="image/x-icon" href="<?php print $shop_url; ?>assets/img/favicon.ico?">

    <!--[if lt IE 9]><script type="text/javascript" src="assets/js/html5.min.js"></script><![endif]-->

</head>

<body>
    <!-- Navigation Bar - Clean and Compact (TOP) -->
    <div class="header">
        <div class="container">
            <nav class="main-navigation">
                <ul class="nav-menu">
                    <li class="nav-item">
                        <a href="<?php print $shop_url; ?>" class="nav-link">
                            <i class="fa fa-home"></i>
                            <span><?php print $lang_shop['site_title']; ?></span>
                        </a>
                    </li>
					<?php if(!is_loggedin()) { ?>
                    <li class="nav-item">
                        <a href="<?php print $shop_url; ?>login" class="nav-link">
                            <i class="fa fa-user"></i>
                            <span><?php print $lang_shop['login']; ?></span>
                        </a>
                    </li>
					<?php } else { ?>
                    <li class="nav-item">
                        <a href="<?php print $shop_url; ?>donations" class="nav-link highlight">
                            <i class="fa fa-heart"></i>
                            <span>Dona</span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<?php print $shop_url; ?>wishlist" class="nav-link">
                            <i class="fa fa-heart-o"></i>
                            <span>Preferiti <?php
                                require_once __DIR__ . '/include/functions/wishlist.php';
                                $wcount = wishlist_count(get_account_id());
                                if($wcount > 0) echo '<span class="badge badge-danger">'.$wcount.'</span>';
                            ?></span>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="<?php print $shop_url; ?>logout" class="nav-link">
                            <i class="fa fa-sign-out"></i>
                            <span><?php print $lang_shop['logout']; ?></span>
                        </a>
                    </li>
					<?php } ?>
					<li class="nav-item dropdown">
						<a class="nav-link dropdown-toggle" data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false">
                            <i class="fa fa-language"></i>
                            <span><?php print $language_codes[$language_code]; ?></span>
                        </a>
						<div class="dropdown-menu">
							<?php
								foreach($language_codes as $key => $value)
									print '<a href="'.$shop_url.'?lang='.$key.'" class="dropdown-item">'.$value.'</a>';
							?>
						</div>
					</li>
                </ul>
            </nav>
        </div>
    </div>

    <!-- Barra di Ricerca Globale 2025 -->
    <?php if(is_loggedin() && $current_page != 'login' && $current_page != 'register') { ?>
    <div class="search-bar-container">
        <div class="container">
            <form method="get" action="" class="global-search-form">
                <input type="hidden" name="p" value="search">
                <div class="search-input-wrapper">
                    <i class="fa fa-search search-icon"></i>
                    <input type="text"
                           name="q"
                           class="search-input"
                           placeholder="Cerca item per nome o vnum..."
                           value="<?php echo isset($_GET['q']) ? htmlspecialchars($_GET['q']) : ''; ?>"
                           autocomplete="off"
                           required>
                    <button type="submit" class="search-button">
                        <i class="fa fa-arrow-right"></i>
                    </button>
                </div>
            </form>
        </div>
    </div>
    <?php } ?>

    <div class="container">
        <div class="row">
            <div class="col-md-<?php if(is_loggedin() || $current_page=='item') print 9; else print 12; ?>">
                <div class="homepage-content" >
					<?php
						switch ($current_page) {
							case 'home':
								include 'pages/shop/home_ultra_gasato.php'; // HOMEPAGE GASATISSIMA 🔥
								break;
							case 'items':
								include 'pages/shop/items.php';
								break;
							case 'category':
								include 'pages/shop/category.php';
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
							case 'dashboard':
								include 'pages/admin/dashboard.php';
								break;
							case 'paypal':
								include 'pages/admin/paypal.php';
								break;
							case 'coins':
								include 'pages/shop/coins.php';
								break;
							case 'donations':
								include 'pages/shop/donations-page-bigsmoke.php';
								break;
							case 'search':
								include 'pages/shop/search.php';
								break;
							case 'wishlist':
								include 'pages/shop/wishlist.php';
								break;
							case 'pay':
								include 'pages/shop/pay.php';
								break;
							default:
								include 'pages/shop/home.php';
						}
						
						if(!is_loggedin() && $current_page!='login')
						{
					?>
					<div class="login-cta-section text-center mt-5 mb-5 animated fadeInUp" style="background: linear-gradient(rgba(0,0,0,0.8), rgba(0,0,0,0.8)), url('<?php print $shop_url; ?>assets/img/login-bg.jpg'); background-size: cover; padding: 50px; border-radius: 20px; border: 1px solid var(--scarlet-dark);">
                        <div class="cta-content">
                            <h2 class="cta-title" style="font-family: var(--font-title); color: #fff; font-size: 2.5rem; margin-bottom: 15px;">Non sei ancora connesso?</h2>
                            <p class="cta-subtitle text-muted mb-4">Accedi per gestire il tuo inventario e acquistare oggetti esclusivi.</p>
                            
                            <div class="cta-form-wrapper d-flex justify-content-center">
                                <form action="<?php print $shop_url; ?>login" method="post" class="form-inline">
                                    <?php echo csrf_token_field(); ?>
                                    <div class="input-group mb-2 mr-sm-2">
                                        <div class="input-group-addon" style="background: var(--scarlet-dark); border: none; color: #fff;"><i class="fa fa-user"></i></div>
                                        <input type="text" class="form-control" name="username" placeholder="<?php print $lang_shop['name_login']; ?>" required style="background: rgba(0,0,0,0.5); border: 1px solid #444; color: #fff;">
                                    </div>
                                    
                                    <div class="input-group mb-2 mr-sm-2">
                                        <div class="input-group-addon" style="background: var(--scarlet-dark); border: none; color: #fff;"><i class="fa fa-lock"></i></div>
                                        <input type="password" class="form-control" name="password" placeholder="<?php print $lang_shop['password']; ?>" required style="background: rgba(0,0,0,0.5); border: 1px solid #444; color: #fff;">
                                    </div>

                                    <button type="submit" class="btn btn-primary mb-2">
                                        <i class="fa fa-sign-in"></i> <?php print $lang_shop['login2']; ?>
                                    </button>
                                </form>
                            </div>
                        </div>
					</div>
					<?php } ?>
                </div>
            </div>
			<?php
				if(is_loggedin()|| $current_page=='item') {
			?>
            <div class="col-md-3">
                <div class="sidebar">
				<?php if(is_loggedin()) { ?>
                    <!-- User Profile Card -->
                    <div class="user-profile-card mb-4 text-center" style="background: rgba(20,20,20,0.6); padding: 20px; border-radius: 15px; border: 1px solid var(--glass-border);">
                        <div class="profile-avatar mb-2">
                            <i class="fa fa-user-circle fa-3x" style="color: var(--scarlet-primary);"></i>
                        </div>
                        <h4 class="account-name mb-1" style="color: #fff; font-family: var(--font-title);"><?php print get_account_name(); ?></h4>
                        <span class="badge badge-danger">Player</span>
                    </div>

                    <!-- Wallet Card -->
                    <a href="<?php print $shop_url; ?>donations" class="wallet-link" style="text-decoration: none;">
                        <div class="wallet-balance-card">
                            <div class="wallet-header">
                                <i class="fa fa-wallet"></i>
                                <span class="wallet-label">Saldo Disponibile</span>
                            </div>
                            <div class="wallet-amount">
                                <img src="<?php print $shop_url; ?>images/md.png" class="wallet-coin-icon" alt="MD Coins">
                                <span class="amount-value"><?php print number_format(is_coins(), 0, '', '.'); ?></span>
                                <span class="amount-currency">MD</span>
                            </div>
                            <div class="wallet-action">
                                <i class="fa fa-plus-circle"></i> Ricarica Ora
                            </div>
                        </div>
                    </a>

                    <!-- Quick Actions Menu -->
                    <div class="list-group sidebar-menu mb-4" style="border-radius: 15px; overflow: hidden;">
                        <a href="<?php print $shop_url; ?>wishlist" class="list-group-item list-group-item-action bg-dark text-white border-secondary">
                            <i class="fa fa-heart text-danger"></i> Lista dei Desideri
                            <?php
                                require_once __DIR__ . '/include/functions/wishlist.php';
                                $wcount = wishlist_count(get_account_id());
                                if($wcount > 0) echo '<span class="badge badge-pill badge-danger pull-right">'.$wcount.'</span>';
                            ?>
                        </a>
                        <?php if(web_admin_level()>=9) { ?>
                        <a href="<?php print $shop_url; ?>dashboard" class="list-group-item list-group-item-action bg-dark text-white border-secondary">
                            <i class="fa fa-tachometer text-info"></i> Dashboard Admin
                        </a>
                        <?php } ?>
                        <a href="<?php print $shop_url; ?>logout" class="list-group-item list-group-item-action bg-dark text-white border-secondary">
                            <i class="fa fa-sign-out text-muted"></i> Disconnetti
                        </a>
                    </div>
				<?php } ?>

				<?php
					if($current_page=='item')
						include 'include/sidebar/info_object.php';
					
					if(is_loggedin()) {
                        // Wrappers for widgets
                        echo '<div class="sidebar-widget mb-4">';
                        include 'include/sidebar/last_bought.php';
                        echo '</div>';
                        
                        echo '<div class="sidebar-widget mb-4">';
                        include 'include/sidebar/most_bought.php';
                        echo '</div>';
					}
				?>
                </div>
            </div>
			<?php } ?>
            <div class="clearfix"></div>
        </div>
    </div>

    <!-- Logo Bar - At Bottom -->
    <div class="logo-bar-bottom">
        <div class="container">
            <a href="<?php print $shop_url; ?>" class="logo-link">
                <img class="site-logo" src="<?php print $shop_url; ?>images/logo.png" alt="ONE Server">
            </a>
        </div>
    </div>

    <!-- ADMIN MODE INDICATOR -->
    <?php if(is_loggedin() && web_admin_level()>=9) { ?>
    <div style="position: fixed; bottom: 20px; right: 20px; background: linear-gradient(135deg, #ff0000 0%, #8a0000 100%); color: white; padding: 10px 20px; z-index: 9999; border-radius: 50px; box-shadow: 0 5px 15px rgba(0,0,0,0.5); font-weight: bold; border: 2px solid #fff;">
        <i class="fa fa-shield"></i> ADMIN MODE
    </div>
    <?php } ?>

    <!-- Footer 10/10 -->
    <footer class="footer">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-4">
                    <h4 class="footer-title" style="color: #fff; font-family: var(--font-title); margin-bottom: 20px;">ONE Server</h4>
                    <p class="text-muted">
                        Il miglior server Metin2 Newstyle. Unisciti alla battaglia e diventa una leggenda.
                        Domina i regni con equipaggiamenti esclusivi.
                    </p>
                    <div class="social-links mt-3">
                        <a href="#" class="btn btn-outline-secondary btn-sm mr-2"><i class="fa fa-facebook"></i></a>
                        <a href="#" class="btn btn-outline-secondary btn-sm mr-2"><i class="fa fa-discord"></i></a>
                        <a href="#" class="btn btn-outline-secondary btn-sm"><i class="fa fa-instagram"></i></a>
                    </div>
                </div>
                <div class="col-md-4 mb-4">
                    <h4 class="footer-title" style="color: #fff; font-family: var(--font-title); margin-bottom: 20px;">Link Rapidi</h4>
                    <ul class="list-unstyled">
                        <li><a href="<?php print $shop_url; ?>" class="text-muted">Home Shop</a></li>
                        <li><a href="<?php print $shop_url; ?>donations" class="text-muted">Donazioni</a></li>
                        <li><a href="#" class="text-muted">Regolamento</a></li>
                        <li><a href="#" class="text-muted">Supporto</a></li>
                    </ul>
                </div>
                <div class="col-md-4 mb-4">
                    <h4 class="footer-title" style="color: #fff; font-family: var(--font-title); margin-bottom: 20px;">Sicurezza</h4>
                    <p class="text-muted small">
                        Tutti i pagamenti sono sicuri e protetti.
                        <br>
                        &copy; <?php print date('Y'); ?> ONE Server - Tutti i diritti riservati.
                    </p>
                    <div class="payment-icons mt-2">
                        <i class="fa fa-paypal fa-2x text-muted mr-2"></i>
                        <i class="fa fa-cc-visa fa-2x text-muted mr-2"></i>
                        <i class="fa fa-cc-mastercard fa-2x text-muted"></i>
                    </div>
                </div>
            </div>
        </div>
    </footer>
	
</body>
    <script src="<?php print $shop_url; ?>assets/js/jquery.js"></script>
    <script src="<?php print $shop_url; ?>assets/js/tether.min.js"></script>
    <script src="<?php print $shop_url; ?>assets/js/bootstrap.min.js"></script>
    <script src="<?php print $shop_url; ?>assets/js/shop-lazyload-2025.js?v=<?php echo time(); ?>"></script>
    <!-- SCARLET UI INTERACTIVITY -->
    <script src="<?php print $shop_url; ?>assets/js/scarlet-ui.js?v=<?php echo time(); ?>"></script>
    <script src="<?php print $shop_url; ?>assets/js/hero-animations.js?v=<?php echo time(); ?>"></script>
    <script src="<?php print $shop_url; ?>assets/js/item-cards-effects.js?v=<?php echo time(); ?>"></script>

    <!-- JS ULTRA-GASATO 🔥 (Toast, Pop-up, Particles, Animations) -->
    <script src="<?php print $shop_url; ?>assets/js/shop-ultra-gasato.js?v=<?php echo time(); ?>"></script>

	<?php include 'include/functions/js.php'; ?>
</html>