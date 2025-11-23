		<?php
			// Ottieni parametri paginazione e filtri
			$current_page = isset($_GET['page']) ? max(1, intval($_GET['page'])) : 1;
			$per_page = 12;

			// Ottieni filtri
			$filters = [];
			if (isset($_GET['price_min']) && $_GET['price_min'] !== '') {
				$filters['price_min'] = intval($_GET['price_min']);
			}
			if (isset($_GET['price_max']) && $_GET['price_max'] !== '') {
				$filters['price_max'] = intval($_GET['price_max']);
			}
			if (isset($_GET['only_discount']) && $_GET['only_discount'] == '1') {
				$filters['only_discount'] = true;
			}
			if (isset($_GET['order_by']) && !empty($_GET['order_by'])) {
				$filters['order_by'] = $_GET['order_by'];
			}

			// Conta totale item
			$total_items = is_items_count($get_category, $filters);
			$total_pages = ceil($total_items / $per_page);

			// Query string per mantenere filtri nella paginazione
			$query_params = $_GET;
			unset($query_params['p']);
			unset($query_params['category']);
			unset($query_params['page']);
		?>

		<?php if(is_loggedin() && web_admin_level()>=9) { ?>
			<a href="<?php print $shop_url.'add/item/'.$get_category.'/'; ?>" class="btn btn-info"><?php print $lang_shop['is_add_items']; ?></a>
			<a href="<?php print $shop_url.'add/bonus/item/'.$get_category.'/'; ?>" class="btn btn-danger"><?php print $lang_shop['is_add_items'].' ['.$lang_shop['bonus_selection'].']'; ?></a>
			</br></br>
		<?php } ?>

			<!-- Breadcrumbs 2025 -->
			<nav aria-label="breadcrumb" class="breadcrumb-modern mb-4">
				<ol class="breadcrumb">
					<li class="breadcrumb-item"><a href="<?php print $shop_url; ?>"><i class="fa fa-home"></i> Home</a></li>
					<li class="breadcrumb-item active"><i class="fa fa-tag"></i> <?php print is_get_category_name($get_category); ?></li>
				</ol>
			</nav>

			<!-- Filtri e Ordinamento -->
			<div class="filters-container mb-4">
				<form method="get" action="" class="filters-form">
					<input type="hidden" name="p" value="items">
					<input type="hidden" name="category" value="<?php print $get_category; ?>">

					<div class="row">
						<div class="col-md-3 col-sm-6 mb-3">
							<label class="filter-label"><i class="fa fa-coins"></i> Prezzo Minimo</label>
							<input type="number" name="price_min" class="form-control" placeholder="MD Min" value="<?php echo isset($_GET['price_min']) ? htmlspecialchars($_GET['price_min']) : ''; ?>">
						</div>
						<div class="col-md-3 col-sm-6 mb-3">
							<label class="filter-label"><i class="fa fa-coins"></i> Prezzo Massimo</label>
							<input type="number" name="price_max" class="form-control" placeholder="MD Max" value="<?php echo isset($_GET['price_max']) ? htmlspecialchars($_GET['price_max']) : ''; ?>">
						</div>
						<div class="col-md-3 col-sm-6 mb-3">
							<label class="filter-label"><i class="fa fa-sort"></i> Ordina Per</label>
							<select name="order_by" class="form-control">
								<option value="">Più Recenti</option>
								<option value="price_asc" <?php echo (isset($_GET['order_by']) && $_GET['order_by'] == 'price_asc') ? 'selected' : ''; ?>>Prezzo Crescente</option>
								<option value="price_desc" <?php echo (isset($_GET['order_by']) && $_GET['order_by'] == 'price_desc') ? 'selected' : ''; ?>>Prezzo Decrescente</option>
								<option value="discount" <?php echo (isset($_GET['order_by']) && $_GET['order_by'] == 'discount') ? 'selected' : ''; ?>>Sconti</option>
							</select>
						</div>
						<div class="col-md-3 col-sm-6 mb-3">
							<label class="filter-label">&nbsp;</label>
							<div class="custom-control custom-checkbox mt-2">
								<input type="checkbox" class="custom-control-input" id="only_discount" name="only_discount" value="1" <?php echo (isset($_GET['only_discount']) && $_GET['only_discount'] == '1') ? 'checked' : ''; ?>>
								<label class="custom-control-label" for="only_discount"><i class="fa fa-percent"></i> Solo Scontati</label>
							</div>
						</div>
					</div>

					<div class="row">
						<div class="col-12">
							<button type="submit" class="btn btn-primary mr-2"><i class="fa fa-filter"></i> Applica Filtri</button>
							<a href="<?php print $shop_url.'category/'.$get_category.'/'; ?>" class="btn btn-secondary"><i class="fa fa-times"></i> Pulisci</a>
							<span class="ml-3 text-muted"><i class="fa fa-info-circle"></i> Trovati <strong><?php echo $total_items; ?></strong> item</span>
						</div>
					</div>
				</form>
			</div>

			<div class="media-section">
				<div class="images">
					<h3 class="section-title">
						<i class="fa fa-list-ul"></i> <?php print is_get_category_name($get_category); ?>
					</h3>

					<!-- Skeleton Loader (nascosto di default) -->
					<div class="skeleton-loader" style="display: none;">
						<div class="row">
							<?php for($i = 0; $i < 12; $i++) { ?>
							<div class="col-md-3 col-sm-6 mb-3">
								<div class="skeleton-card">
									<div class="skeleton-img"></div>
									<div class="skeleton-text"></div>
									<div class="skeleton-text short"></div>
								</div>
							</div>
							<?php } ?>
						</div>
					</div>

					<div class="row items-grid">
						<?php
							$list = is_items_list_paginated($get_category, $current_page, $per_page, $filters);

							if(!count($list)) {
								echo '<div class="col-12"><div class="alert alert-info"><i class="fa fa-info-circle"></i> Nessun item trovato con questi filtri.</div></div>';
							} else {
								foreach($list as $row) {
						?>
							<div class="col-md-3 item-with-wishlist">
								<?php
									// Wishlist button
									require_once __DIR__ . '/../../include/functions/wishlist.php';
									$account_id = get_account_id();
									$in_wishlist = wishlist_has($account_id, $row['id']);
									$item_name = !$item_name_db ? get_item_name($row['vnum']) : get_item_name_locale_name($row['vnum']);
								?>
								<a href="<?php print $shop_url.'wishlist?action='.($in_wishlist ? 'remove' : 'add').'&item_id='.$row['id'].'&vnum='.$row['vnum'].'&name='.urlencode($item_name).'&price='.$row['coins']; ?>"
								   class="wishlist-heart-btn <?php echo $in_wishlist ? 'in-wishlist' : ''; ?>"
								   onclick="return confirm('<?php echo $in_wishlist ? 'Rimuovere dai preferiti?' : 'Aggiungere ai preferiti?'; ?>')">
									<i class="fa fa-heart<?php echo $in_wishlist ? '' : '-o'; ?>"></i>
								</a>

								<a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>">
									<div class="card mb-3 text-center">
										<div class="card-block">
											<!-- Badge NUOVO per item recenti -->
											<?php if(is_item_new($row['id'])) { ?>
											<span class="badge badge-new-item">
												<i class="fa fa-star"></i> NUOVO
											</span>
											<?php } ?>

											<div class="min-image-item">
												<center>
													<img class="image-item" src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png">
												</center>
											</div>
											<?php if($row['discount']>0) { ?>
											<span class="badge badge-danger font-weight-bold strong pull-right">- <?php print $row['discount']; ?>%</span>
											<?php }
												if($row['expire']>0) {
													$expire = date("Y-m-d H:i:s", $row['expire']);
											?>
											<p class="card-text"><small class="font-weight-bold strong pull-right text-danger" data-countdown="<?php print $expire; ?>"></small></p>
											<?php }
												if($row['type']==3) {
											?>
											<p class="card-text"><small class="font-weight-bold strong pull-right text-danger"><?php print $lang_shop['bonus_selection']; ?></small></p>
											<?php } ?>
										</div>
										<div class="card-footer text-muted">
											<div class="item-name-truncate">
												<a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>"><?php if(!$item_name_db) print get_item_name($row['vnum']); else print get_item_name_locale_name($row['vnum']); ?></a>
											</div>
											<div class="item-price-tag">
												<?php if($row['discount'] > 0) { 
													$discounted_price = round($row['coins'] - ($row['coins'] * $row['discount'] / 100));
												?>
													<span class="old-price"><?php echo $row['coins']; ?> MD</span>
													<span class="current-price"><?php echo $discounted_price; ?> MD</span>
												<?php } else { ?>
													<span class="current-price"><?php echo $row['coins']; ?> MD</span>
												<?php } ?>
											</div>
										</div>
									</div>
								</a>

							</div>
						<?php } } ?>
					</div>

					<!-- Paginazione -->
					<?php if($total_pages > 1) { ?>
					<nav aria-label="Paginazione item" class="mt-4">
						<ul class="pagination pagination-modern justify-content-center">
							<?php
								// Prima pagina
								if($current_page > 1) {
									$first_url = http_build_query(array_merge($query_params, ['p' => 'items', 'category' => $get_category, 'page' => 1]));
									echo '<li class="page-item"><a class="page-link" href="?'.$first_url.'"><i class="fa fa-angle-double-left"></i></a></li>';

									$prev_url = http_build_query(array_merge($query_params, ['p' => 'items', 'category' => $get_category, 'page' => $current_page - 1]));
									echo '<li class="page-item"><a class="page-link" href="?'.$prev_url.'"><i class="fa fa-angle-left"></i> Indietro</a></li>';
								}

								// Pagine numerate (mostra max 5 pagine)
								$start_page = max(1, $current_page - 2);
								$end_page = min($total_pages, $current_page + 2);

								if($start_page > 1) {
									echo '<li class="page-item disabled"><span class="page-link">...</span></li>';
								}

								for($i = $start_page; $i <= $end_page; $i++) {
									$page_url = http_build_query(array_merge($query_params, ['p' => 'items', 'category' => $get_category, 'page' => $i]));
									$active = $i == $current_page ? 'active' : '';
									echo '<li class="page-item '.$active.'"><a class="page-link" href="?'.$page_url.'">'.$i.'</a></li>';
								}

								if($end_page < $total_pages) {
									echo '<li class="page-item disabled"><span class="page-link">...</span></li>';
								}

								// Ultima pagina
								if($current_page < $total_pages) {
									$next_url = http_build_query(array_merge($query_params, ['p' => 'items', 'category' => $get_category, 'page' => $current_page + 1]));
									echo '<li class="page-item"><a class="page-link" href="?'.$next_url.'">Avanti <i class="fa fa-angle-right"></i></a></li>';

									$last_url = http_build_query(array_merge($query_params, ['p' => 'items', 'category' => $get_category, 'page' => $total_pages]));
									echo '<li class="page-item"><a class="page-link" href="?'.$last_url.'"><i class="fa fa-angle-double-right"></i></a></li>';
								}
							?>
						</ul>
						<p class="text-center text-muted mt-2">
							Pagina <?php echo $current_page; ?> di <?php echo $total_pages; ?> (<?php echo $total_items; ?> item totali)
						</p>
					</nav>
					<?php } ?>
				</div>
			</div>
