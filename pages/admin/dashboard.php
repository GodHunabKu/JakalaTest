<?php
	// Dashboard Admin con Statistiche Avanzate
	if(web_admin_level()<9) {
		redirect($shop_url);
		exit;
	}

	// Ottieni statistiche
	$stats = [];

	// 1. Totale item nello shop
	$sth = $database->runQuerySqlite('SELECT COUNT(*) as total FROM item_shop_items');
	$sth->execute();
	$stats['total_items'] = $sth->fetch()['total'];

	// 2. Totale categorie
	$sth = $database->runQuerySqlite('SELECT COUNT(*) as total FROM item_shop_categories');
	$sth->execute();
	$stats['total_categories'] = $sth->fetch()['total'];

	// 3. Item con sconto attivo
	$sth = $database->runQuerySqlite('SELECT COUNT(*) as total FROM item_shop_items WHERE discount > 0');
	$sth->execute();
	$stats['items_on_sale'] = $sth->fetch()['total'];

	// 4. Item scaduti
	$now = time();
	$sth = $database->runQuerySqlite('SELECT COUNT(*) as total FROM item_shop_items WHERE expire > 0 AND expire < ?');
	$sth->bindParam(1, $now, PDO::PARAM_INT);
	$sth->execute();
	$stats['expired_items'] = $sth->fetch()['total'];

	// 5. Item più costosi (top 5)
	$sth = $database->runQuerySqlite('SELECT id, vnum, coins, discount FROM item_shop_items ORDER BY coins DESC LIMIT 5');
	$sth->execute();
	$stats['most_expensive'] = $sth->fetchAll();

	// 6. Item con maggior sconto (top 5)
	$sth = $database->runQuerySqlite('SELECT id, vnum, coins, discount FROM item_shop_items WHERE discount > 0 ORDER BY discount DESC LIMIT 5');
	$sth->execute();
	$stats['highest_discounts'] = $sth->fetchAll();

	// 7. Item per categoria
	$sth = $database->runQuerySqlite('
		SELECT c.name as category_name, COUNT(i.id) as item_count
		FROM item_shop_categories c
		LEFT JOIN item_shop_items i ON c.id = i.category
		GROUP BY c.id, c.name
		ORDER BY item_count DESC
	');
	$sth->execute();
	$stats['items_per_category'] = $sth->fetchAll();

	// 8. Item più popolari dal file tracking
	require_once __DIR__ . '/../../include/functions/popular_items.php';
	$stats['most_popular'] = get_most_popular(10);

	// 9. Item più recenti
	$stats['newest_items'] = is_get_newest_items(5);
?>

<div class="admin-dashboard">
	<div class="dashboard-header mb-4">
		<h1 class="dashboard-title">
			<i class="fa fa-tachometer"></i> Dashboard Amministratore
		</h1>
		<p class="dashboard-subtitle">Panoramica completa del tuo shop</p>
	</div>

	<!-- Statistiche Generali Cards -->
	<div class="row mb-4">
		<div class="col-lg-3 col-md-6 mb-3">
			<div class="stat-card stat-primary">
				<div class="stat-icon">
					<i class="fa fa-cubes"></i>
				</div>
				<div class="stat-content">
					<h3 class="stat-value"><?php echo number_format($stats['total_items']); ?></h3>
					<p class="stat-label">Item Totali</p>
				</div>
			</div>
		</div>

		<div class="col-lg-3 col-md-6 mb-3">
			<div class="stat-card stat-success">
				<div class="stat-icon">
					<i class="fa fa-tags"></i>
				</div>
				<div class="stat-content">
					<h3 class="stat-value"><?php echo $stats['total_categories']; ?></h3>
					<p class="stat-label">Categorie Attive</p>
				</div>
			</div>
		</div>

		<div class="col-lg-3 col-md-6 mb-3">
			<div class="stat-card stat-warning">
				<div class="stat-icon">
					<i class="fa fa-percent"></i>
				</div>
				<div class="stat-content">
					<h3 class="stat-value"><?php echo $stats['items_on_sale']; ?></h3>
					<p class="stat-label">Item in Offerta</p>
				</div>
			</div>
		</div>

		<div class="col-lg-3 col-md-6 mb-3">
			<div class="stat-card stat-danger">
				<div class="stat-icon">
					<i class="fa fa-clock-o"></i>
				</div>
				<div class="stat-content">
					<h3 class="stat-value"><?php echo $stats['expired_items']; ?></h3>
					<p class="stat-label">Item Scaduti</p>
				</div>
			</div>
		</div>
	</div>

	<!-- Grafici e Tabelle -->
	<div class="row">
		<!-- Item per Categoria -->
		<div class="col-lg-6 mb-4">
			<div class="dashboard-panel">
				<div class="panel-header">
					<h3><i class="fa fa-pie-chart"></i> Item per Categoria</h3>
				</div>
				<div class="panel-body">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>Categoria</th>
								<th class="text-right">Numero Item</th>
								<th class="text-right">%</th>
							</tr>
						</thead>
						<tbody>
							<?php foreach($stats['items_per_category'] as $cat) {
								$percentage = $stats['total_items'] > 0 ? round(($cat['item_count'] / $stats['total_items']) * 100, 1) : 0;
							?>
							<tr>
								<td><strong><?php echo htmlspecialchars($cat['category_name']); ?></strong></td>
								<td class="text-right"><?php echo $cat['item_count']; ?></td>
								<td class="text-right">
									<span class="badge badge-primary"><?php echo $percentage; ?>%</span>
								</td>
							</tr>
							<?php } ?>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- Item Più Popolari -->
		<div class="col-lg-6 mb-4">
			<div class="dashboard-panel">
				<div class="panel-header">
					<h3><i class="fa fa-fire"></i> Item Più Acquistati</h3>
				</div>
				<div class="panel-body">
					<?php if(count($stats['most_popular']) > 0) { ?>
					<table class="table table-hover">
						<thead>
							<tr>
								<th>Item</th>
								<th class="text-right">Prezzo</th>
								<th class="text-right">Acquisti</th>
							</tr>
						</thead>
						<tbody>
							<?php foreach($stats['most_popular'] as $item) { ?>
							<tr>
								<td><strong><?php echo htmlspecialchars($item['name']); ?></strong></td>
								<td class="text-right"><?php echo number_format($item['price']); ?> MD</td>
								<td class="text-right">
									<span class="badge badge-success"><?php echo $item['count']; ?>x</span>
								</td>
							</tr>
							<?php } ?>
						</tbody>
					</table>
					<?php } else { ?>
					<p class="text-muted text-center py-4">Nessun acquisto registrato ancora</p>
					<?php } ?>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<!-- Item Più Costosi -->
		<div class="col-lg-6 mb-4">
			<div class="dashboard-panel">
				<div class="panel-header">
					<h3><i class="fa fa-diamond"></i> Item Più Costosi</h3>
				</div>
				<div class="panel-body">
					<table class="table table-hover">
						<thead>
							<tr>
								<th>Item</th>
								<th class="text-right">Prezzo</th>
								<th class="text-right">Sconto</th>
							</tr>
						</thead>
						<tbody>
							<?php foreach($stats['most_expensive'] as $item) {
								$item_name = $item_name_db ? get_item_name_locale_name($item['vnum']) : get_item_name($item['vnum']);
								$final_price = $item['discount'] > 0 ? $item['coins'] - ($item['coins'] * $item['discount'] / 100) : $item['coins'];
							?>
							<tr>
								<td>
									<a href="<?php print $shop_url.'item/'.$item['id'].'/'; ?>" class="text-white">
										<?php echo htmlspecialchars($item_name); ?>
									</a>
								</td>
								<td class="text-right">
									<?php if($item['discount'] > 0) { ?>
										<del><?php echo number_format($item['coins']); ?></del>
										<strong class="text-success"><?php echo number_format($final_price); ?> MD</strong>
									<?php } else { ?>
										<strong><?php echo number_format($item['coins']); ?> MD</strong>
									<?php } ?>
								</td>
								<td class="text-right">
									<?php if($item['discount'] > 0) { ?>
										<span class="badge badge-danger">-<?php echo $item['discount']; ?>%</span>
									<?php } else { ?>
										<span class="text-muted">-</span>
									<?php } ?>
								</td>
							</tr>
							<?php } ?>
						</tbody>
					</table>
				</div>
			</div>
		</div>

		<!-- Sconti Maggiori -->
		<div class="col-lg-6 mb-4">
			<div class="dashboard-panel">
				<div class="panel-header">
					<h3><i class="fa fa-percent"></i> Sconti Più Alti</h3>
				</div>
				<div class="panel-body">
					<?php if(count($stats['highest_discounts']) > 0) { ?>
					<table class="table table-hover">
						<thead>
							<tr>
								<th>Item</th>
								<th class="text-right">Prezzo Originale</th>
								<th class="text-right">Sconto</th>
							</tr>
						</thead>
						<tbody>
							<?php foreach($stats['highest_discounts'] as $item) {
								$item_name = $item_name_db ? get_item_name_locale_name($item['vnum']) : get_item_name($item['vnum']);
							?>
							<tr>
								<td>
									<a href="<?php print $shop_url.'item/'.$item['id'].'/'; ?>" class="text-white">
										<?php echo htmlspecialchars($item_name); ?>
									</a>
								</td>
								<td class="text-right"><?php echo number_format($item['coins']); ?> MD</td>
								<td class="text-right">
									<span class="badge badge-danger">-<?php echo $item['discount']; ?>%</span>
								</td>
							</tr>
							<?php } ?>
						</tbody>
					</table>
					<?php } else { ?>
					<p class="text-muted text-center py-4">Nessun item in offerta al momento</p>
					<?php } ?>
				</div>
			</div>
		</div>
	</div>

	<!-- Item Più Recenti -->
	<div class="row">
		<div class="col-12">
			<div class="dashboard-panel">
				<div class="panel-header">
					<h3><i class="fa fa-star"></i> Ultimi Item Aggiunti</h3>
				</div>
				<div class="panel-body">
					<div class="row">
						<?php foreach($stats['newest_items'] as $item) {
							$item_name = $item_name_db ? get_item_name_locale_name($item['vnum']) : get_item_name($item['vnum']);
						?>
						<div class="col-lg-2 col-md-3 col-sm-4 col-6 mb-3">
							<a href="<?php print $shop_url.'item/'.$item['id'].'/'; ?>">
								<div class="newest-item-preview">
									<img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item['vnum']); ?>.png"
									     class="img-fluid" alt="<?php echo htmlspecialchars($item_name); ?>">
									<p class="item-name"><?php echo htmlspecialchars($item_name); ?></p>
									<p class="item-price"><?php echo number_format($item['coins']); ?> MD</p>
								</div>
							</a>
						</div>
						<?php } ?>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- Quick Actions -->
	<div class="row mt-4">
		<div class="col-12">
			<div class="quick-actions-panel">
				<h3 class="mb-3"><i class="fa fa-bolt"></i> Azioni Rapide</h3>
				<div class="btn-group-actions">
					<a href="<?php print $shop_url; ?>categories" class="btn btn-primary">
						<i class="fa fa-cog"></i> Gestisci Categorie
					</a>
					<a href="<?php print $shop_url; ?>category/1/" class="btn btn-success">
						<i class="fa fa-plus"></i> Aggiungi Item
					</a>
					<a href="<?php print $shop_url; ?>admin/paypal" class="btn btn-info">
						<i class="fa fa-dollar"></i> Gestione Pagamenti
					</a>
					<a href="<?php print $shop_url; ?>settings" class="btn btn-warning">
						<i class="fa fa-wrench"></i> Impostazioni
					</a>
				</div>
			</div>
		</div>
	</div>
</div>
