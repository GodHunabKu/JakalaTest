<!-- Admin Quick Access -->

<?php if(is_loggedin() && web_admin_level()>=9) { ?>

<div class="admin-toolbar mb-4">

	<a href="<?php print $shop_url; ?>categories" class="btn btn-info btn-sm">

		<i class="fa fa-cog"></i> <?php print $lang_shop['administration_categories']; ?>

	</a>

	<a href="<?php print $shop_url; ?>admin/paypal" class="btn btn-success btn-sm">

		<i class="fa fa-dollar"></i> <?php print $lang_shop['administration_pp']; ?>

	</a>

</div>

<?php } ?>



<!-- HERO SECTION (Slider) -->

<div id="heroCarousel" class="carousel slide mb-5 shadow-lg" data-ride="carousel" style="border-radius: 15px; overflow: hidden; border: 1px solid rgba(255,255,255,0.1);">

    <ol class="carousel-indicators">

        <li data-target="#heroCarousel" data-slide-to="0" class="active"></li>

        <li data-target="#heroCarousel" data-slide-to="1"></li>

    </ol>

    <div class="carousel-inner">

        <!-- Slide 1: Welcome -->

        <div class="carousel-item active" style="height: 320px; background: linear-gradient(135deg, #2c0505 0%, #000000 100%);">

            <div class="row h-100 align-items-center m-0">

                <div class="col-md-7 p-5 text-left">

                    <h1 class="display-4 font-weight-bold text-white mb-3" style="text-shadow: 0 0 20px rgba(255,0,0,0.6); font-family: var(--font-title);">

                        Dominia il Gioco

                    </h1>

                    <p class="lead text-light mb-4" style="opacity: 0.9;">

                        Scopri gli item più potenti e rari del server. Equipaggiati per la vittoria.

                    </p>

                    <a href="#new-arrivals" class="btn btn-danger btn-lg px-4 py-2 shadow-danger" style="border-radius: 50px; text-transform: uppercase; letter-spacing: 1px; font-weight: bold;">

                        <i class="fa fa-shopping-cart"></i> Inizia lo Shopping

                    </a>

                </div>

                <div class="col-md-5 h-100 d-none d-md-block" style="background: url('<?php print $shop_url; ?>assets/img/hero-char.png') no-repeat center center; background-size: contain;">

                    <!-- Placeholder per immagine personaggio -->

                    <div style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; opacity: 0.3;">

                        <i class="fa fa-gamepad" style="font-size: 150px; color: #fff;"></i>

                    </div>

                </div>

            </div>

        </div>

        <!-- Slide 2: Offers -->

        <div class="carousel-item" style="height: 320px; background: linear-gradient(135deg, #1a1a1a 0%, #2d2d2d 100%);">

             <div class="row h-100 align-items-center m-0">

                <div class="col-md-12 text-center">

                    <h1 class="display-4 font-weight-bold text-warning mb-3" style="text-shadow: 0 0 20px rgba(255, 215, 0, 0.4); font-family: var(--font-title);">

                        <i class="fa fa-bolt"></i> Offerte Lampo

                    </h1>

                    <p class="lead text-white mb-4">Sconti esclusivi solo per questa settimana.</p>

                    <a href="<?php print $shop_url; ?>categories" class="btn btn-outline-warning btn-lg px-5 py-2" style="border-radius: 50px; border-width: 2px; font-weight: bold;">

                        Vedi Offerte

                    </a>

                </div>

            </div>

        </div>

    </div>

    <a class="carousel-control-prev" href="#heroCarousel" role="button" data-slide="prev">

        <span class="carousel-control-prev-icon" aria-hidden="true"></span>

    </a>

    <a class="carousel-control-next" href="#heroCarousel" role="button" data-slide="next">

        <span class="carousel-control-next-icon" aria-hidden="true"></span>

    </a>

</div>



<!-- BEST SELLERS STRIP -->

<?php

    require_once __DIR__ . '/../../include/functions/popular_items.php';

    $best_sellers = get_most_popular(4);

    

    if(count($best_sellers) > 0) {

?>

<div class="best-sellers-section mb-5">

    <div class="d-flex align-items-center justify-content-between mb-3">

        <h4 class="text-white m-0" style="font-family: var(--font-title); border-left: 4px solid var(--gold-accent); padding-left: 15px;">

            <i class="fa fa-fire text-danger"></i> I Più Venduti

        </h4>

        <span class="badge badge-warning text-dark">TRENDING</span>

    </div>

    

    <div class="row">

        <?php foreach($best_sellers as $item) { 

             // Recupera immagine se possibile (assumendo che track_purchase salvi dati base, ma per immagine serve query o helper)

             // Per semplicità usiamo get_item_image se disponibile o placeholder

             $img_src = function_exists('get_item_image') ? get_item_image($item['vnum']) : 'default';

        ?>

        <div class="col-md-3 col-6 mb-3">

            <div class="card bg-dark text-white border-0 shadow-sm h-100" style="background: rgba(30,30,30,0.8) !important; border-radius: 10px; transition: transform 0.2s;">

                <div class="card-body p-3 text-center">

                    <div class="position-absolute" style="top: 10px; left: 10px;">

                        <span class="badge badge-danger rounded-circle p-2">HOT</span>

                    </div>

                    <img src="<?php print $shop_url; ?>images/items/<?php print $img_src; ?>.png" class="img-fluid mb-2" style="max-height: 60px; filter: drop-shadow(0 0 5px rgba(255,255,255,0.2));">

                    <h6 class="text-truncate mb-1" style="font-size: 0.9rem;"><?php echo htmlspecialchars($item['name']); ?></h6>

                    <span class="text-warning font-weight-bold"><?php echo $item['price']; ?> MD</span>

                    <a href="<?php print $shop_url.'item/'.(isset($item['id']) ? $item['id'] : is_search_items_global($item['vnum'])[0]['id']); ?>/" class="stretched-link"></a>

                </div>

            </div>

        </div>

        <?php } ?>
    </div>

</div>

<?php } ?>



<!-- Nuovi Arrivi Section -->

<?php

	try {

		$newest_items = is_get_newest_items(8);

		if(is_array($newest_items) && count($newest_items) > 0) {

?>

<div id="new-arrivals" class="newest-items-section mb-5 animated fadeIn">

	<div class="section-header mb-4 d-flex align-items-center justify-content-between">

		<h2 class="section-title-large m-0" style="font-size: 1.8rem;">

			<i class="fa fa-star text-warning"></i> Nuovi Arrivi

		</h2>

        <a href="<?php print $shop_url; ?>categories" class="text-muted" style="font-size: 0.9rem;">Vedi tutti <i class="fa fa-angle-right"></i></a>

	</div>



	<div class="row">

		<?php

			require_once __DIR__ . '/../../include/functions/wishlist.php';

			$account_id = get_account_id();



			foreach($newest_items as $row) {

				$in_wishlist = wishlist_has($account_id, $row['id']);

				$item_name = !$item_name_db ? get_item_name($row['vnum']) : get_item_name_locale_name($row['vnum']);

		?>

		<div class="col-lg-3 col-md-4 col-sm-6 mb-4">

			<div class="newest-item-card item-with-wishlist h-100" style="background: rgba(20,20,20,0.6); border: 1px solid rgba(255,255,255,0.05); border-radius: 12px; overflow: hidden;">

				<!-- Bottone Wishlist -->

				<a href="<?php print $shop_url.'wishlist?action='.($in_wishlist ? 'remove' : 'add').'&item_id='.$row['id'].'&vnum='.$row['vnum'].'&name='.urlencode($item_name).'&price='.$row['coins']; ?>"

				   class="wishlist-heart-btn <?php echo $in_wishlist ? 'in-wishlist' : ''; ?>"

				   onclick="return confirm('<?php echo $in_wishlist ? 'Rimuovere dai preferiti?' : 'Aggiungere ai preferiti?'; ?>')"

                   style="position: absolute; top: 10px; right: 10px; z-index: 10; color: #ccc;">

					<i class="fa fa-heart<?php echo $in_wishlist ? '' : '-o'; ?>"></i>

				</a>



				<a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" style="text-decoration: none;">

					<div class="card text-center bg-transparent border-0 h-100">

						<div class="card-block p-3">

							<!-- Badge NUOVO -->

							<span class="badge badge-primary position-absolute" style="top: 10px; left: 10px; background: linear-gradient(45deg, #007bff, #00c6ff);">

								NEW

							</span>



                            <div class="min-image-item mb-3 mt-2" style="height: 120px; display: flex; align-items: center; justify-content: center;">

                                <img class="image-item img-fluid" src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png" style="max-height: 100px; filter: drop-shadow(0 5px 10px rgba(0,0,0,0.5)); transition: transform 0.3s;">

                            </div>



                            <?php if($row['discount']>0) { ?>

                            <span class="badge badge-danger font-weight-bold position-absolute" style="bottom: 80px; right: 10px;">- <?php print $row['discount']; ?>%</span>

                            <?php } ?>

                            

                            <h5 class="card-title text-white text-truncate mt-2" style="font-size: 1rem; font-weight: 600;"><?php echo $item_name; ?></h5>

                            

                            <div class="item-price-tag mt-2">

								<?php if($row['discount'] > 0) { 

									$discounted_price = round($row['coins'] - ($row['coins'] * $row['discount'] / 100));

								?>

									<span class="old-price text-muted" style="text-decoration: line-through; font-size: 0.9rem;"><?php echo $row['coins']; ?></span>

									<span class="current-price text-warning font-weight-bold" style="font-size: 1.2rem;"><?php echo $discounted_price; ?> MD</span>

								<?php } else { ?>

									<span class="current-price text-warning font-weight-bold" style="font-size: 1.2rem;"><?php echo $row['coins']; ?> MD</span>

								<?php } ?>

							</div>

						</div>

                        <div class="card-footer bg-transparent border-top border-secondary p-2">

                            <button class="btn btn-sm btn-block btn-outline-light" style="border-radius: 20px; font-size: 0.8rem;">

                                <i class="fa fa-eye"></i> Dettagli

                            </button>

                        </div>

					</div>

				</a>

			</div>

		</div>

		<?php } ?>

	</div>

</div>

<?php

		}

	} catch (Exception $e) {

		error_log("Error loading newest items: " . $e->getMessage());

	}

?>



<!-- Categories Grid - Professional MMORPG Layout -->

<div class="categories-showcase animated fadeInUp">

	<div class="section-header text-center mb-5">

		<h2 class="section-title-large" style="font-family: var(--font-title); font-size: 2rem; color: #fff; text-transform: uppercase; letter-spacing: 2px;">

            <span style="color: var(--scarlet-primary);">Arsenale</span> Completo

        </h2>

		<p class="section-subtitle text-muted">Scegli la tua categoria e domina il server</p>

        <div style="width: 100px; height: 3px; background: var(--scarlet-primary); margin: 10px auto;"></div>

	</div>

	<div class="row justify-content-center g-4">

		<?php

			$list = array();

			$list = is_categories_list();



			if(!count($list)) {

				echo '<div class="col-12 text-center"><p class="text-muted">Nessuna categoria disponibile</p></div>';

			} else {

				foreach($list as $row) {

					$hasPromo = checkForPromotions($row['id']);

		?>

		<div class="col-lg-4 col-md-6 col-sm-12 mb-4">

			<a href="<?php print $shop_url.'category/'.$row['id'].'/'; ?>" class="category-card-link" style="text-decoration: none;">

				<div class="category-card position-relative overflow-hidden shadow-lg" style="border-radius: 15px; height: 200px; background: #1a1a1a; border: 1px solid #333; transition: all 0.3s;">

					<?php if($hasPromo) { ?>

					<div class="promo-badge position-absolute bg-danger text-white px-3 py-1" style="top: 15px; right: -30px; transform: rotate(45deg); font-size: 0.8rem; font-weight: bold; width: 120px; text-align: center; box-shadow: 0 2px 5px rgba(0,0,0,0.5);">

						PROMO

					</div>

					<?php } ?>



					<div class="category-card-image h-100 w-100 d-flex align-items-center justify-content-center" style="background: radial-gradient(circle, rgba(60,20,20,1) 0%, rgba(0,0,0,1) 100%);">

						<img src="<?php print $shop_url; ?>images/items/img_categorie/<?php print $row['img']; ?>.png"

						     alt="<?php print $row['name']; ?>"

                             class="img-fluid"

                             style="max-height: 120px; filter: drop-shadow(0 10px 20px rgba(0,0,0,0.8)); transition: transform 0.4s;"

						     onerror="this.onerror=null; this.src='<?php print $shop_url; ?>images/default-category.png';">

					</div>



                    <div class="category-overlay position-absolute w-100 h-100 d-flex align-items-end p-3" style="top: 0; left: 0; background: linear-gradient(to top, rgba(0,0,0,0.9) 0%, rgba(0,0,0,0) 60%);">

                        <div class="w-100 d-flex justify-content-between align-items-center">

                            <h3 class="category-name text-white m-0" style="font-family: var(--font-title); font-size: 1.4rem; text-shadow: 0 2px 4px rgba(0,0,0,0.8);"><?php print $row['name']; ?></h3>

                            <i class="fa fa-arrow-right text-danger" style="font-size: 1.2rem; opacity: 0.8;"></i>

                        </div>

                    </div>

				</div>

			</a>

		</div>

		<?php

				}

			}

		?>

	</div>

</div>



<style>

    /* Inline styles for immediate impact - move to CSS later */

    .category-card:hover {

        transform: translateY(-5px);

        border-color: var(--scarlet-primary) !important;

        box-shadow: 0 10px 30px rgba(255, 0, 0, 0.2) !important;

    }

    .category-card:hover img {

        transform: scale(1.1) rotate(5deg);

    }

    .newest-item-card:hover {

        transform: translateY(-5px);

        box-shadow: 0 10px 20px rgba(0,0,0,0.5);

        border-color: var(--gold-accent) !important;

    }

    .carousel-item {

        transition: transform 0.6s ease-in-out;

    }

</style>