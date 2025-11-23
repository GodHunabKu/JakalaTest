<?php
    // Logic for Buy Action
    if(is_loggedin()) {
        // Handle Edit Item
        if(isset($_POST['edit_item']) && web_admin_level()>=9) {
            $edit_vnum = intval($_POST['edit_vnum']);
            $edit_count = intval($_POST['edit_count']);
            $edit_coins = intval($_POST['edit_coins']);
            $edit_desc = $_POST['edit_description'];
            
            is_edit_item($get_item, $edit_vnum, $edit_count, $edit_coins, $edit_desc);
            
            // Refresh item data
            $item = is_item_select($get_item);
            $ok = 3; // Success code for edit
        }

        if(isset($_POST['buy']) && isset($_POST['buy_key']) && $_POST['buy_key'] == $_SESSION['buy_key'])
        {
            $ok = 0;
            
            // SECURITY FIX: Use atomic transaction function instead of check-then-act
            // Old insecure code: if($total<=is_coins(0)) { ... }
            
            $buy_bonuses = array();
            $bonuses_ok = true;
            
            if($item[0]['type']==3) {
                for($i=0;$i<$count;$i++)
                {
                    if(isset($_POST['attrtype'.$i]) && isset($bonuses['bonus'.$_POST['attrtype'.$i]]) && intval($bonuses['bonus'.$_POST['attrtype'.$i]])!=0)
                        $buy_bonuses[] = intval($_POST['attrtype'.$i]);
                    else {
                        $bonuses_ok = false;
                        break;
                    }
                }
            }
            
            if(count($buy_bonuses) !== count(array_unique($buy_bonuses)))
                $bonuses_ok = false;
                
            if($bonuses_ok)
            {
                // Attempt atomic purchase
                if(attempt_pay_coins(0, $total)) {
                    // Payment successful, now deliver item
                    if(is_buy_item($get_item, $buy_bonuses)) {
                        $ok = 1;
                        
                        // Track purchase
                        require_once __DIR__ . '/../../include/functions/popular_items.php';
                        $item_name_track = $item_name_db ? get_item_name_locale_name($item[0]['vnum']) : get_item_name($item[0]['vnum']);
                        track_purchase($item[0]['vnum'], $item_name_track, $total);

                        // Remove from wishlist if present
                        require_once __DIR__ . '/../../include/functions/wishlist.php';
                        wishlist_remove(get_account_id(), $get_item);
                    } else {
                        // Item delivery failed, refund coins
                        refund_coins(0, $total);
                        $ok = 2; // Error state
                    }
                } else {
                    // Insufficient funds or race condition caught
                    $ok = 2; 
                }
            } else { 
                $ok=2; 
            }
        }
        $_SESSION['buy_key'] = mt_rand(1, 1000);
    }
?>

<!-- Admin Toolbar -->
<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="card mb-4 border-danger" style="background: rgba(20,0,0,0.8); position: relative; z-index: 100; transform: none !important; transition: none !important;">
    <div class="card-header bg-danger text-white">
        <i class="fa fa-cogs"></i> Amministrazione Item
    </div>
    <div class="card-body">
        <div class="d-flex">
            <a href="<?php print $shop_url.'?p=items&remove='.$get_item.'&category='.$item[0]['category']; ?>" 
               class="btn btn-danger mr-2" 
               onclick="return confirm('Sei sicuro di voler eliminare questo item?')">
                <i class="fa fa-trash"></i> Rimuovere Oggetto
            </a>
            <button class="btn btn-warning mr-2" type="button" data-toggle="modal" data-target="#editItemModal">
                <i class="fa fa-pencil"></i> Modifica Dati
            </button>
            <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#discountPanel">
                <i class="fa fa-percent"></i> Gestisci Sconto
            </button>
        </div>
        
        <div class="collapse mt-3" id="discountPanel">
            <form action="" method="post" class="form-inline">
                <div class="input-group mr-2 mb-2">
                    <div class="input-group-prepend"><span class="input-group-text">Valore %</span></div>
                    <input class="form-control" name="discount_value" type="number" min="1" max="100" value="25" required>
                </div>
                
                <div class="input-group mr-2 mb-2">
                    <div class="input-group-prepend"><span class="input-group-text">Giorni</span></div>
                    <input class="form-control" type="number" value="30" name="discount_days" min="0" required>
                </div>

                <div class="input-group mr-2 mb-2">
                    <div class="input-group-prepend"><span class="input-group-text">Ore</span></div>
                    <input class="form-control" type="number" value="0" name="discount_hours" min="0" required>
                </div>
                
                <button type="submit" name="add_discount" class="btn btn-success mb-2" onclick="return confirm('Applicare lo sconto?')">
                    <i class="fa fa-check"></i> Applica
                </button>
            </form>
        </div>
    </div>
</div>
<?php } ?>

<!-- Notifications -->
<?php if(isset($ok)) { ?>
    <?php if($ok==1) { ?>
        <div class="alert alert-dismissible alert-success mb-4">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <i class="fa fa-check-circle"></i> <?php print $lang_shop['successfully_bought']; ?>
        </div>
    <?php } else if($ok==2) { ?>
        <div class="alert alert-dismissible alert-danger mb-4">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <i class="fa fa-times-circle"></i> <?php if(isset($bonuses_ok) && $bonuses_ok) print $lang_shop['no_space']; else print 'Errore durante l\'acquisto (Bonus non validi o spazio insufficiente).'; ?>
        </div>
    <?php } else if($ok==0) { ?>
        <div class="alert alert-dismissible alert-danger mb-4">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <i class="fa fa-times-circle"></i> Errore generico.
        </div>
    <?php } else if($ok==3) { ?>
        <div class="alert alert-dismissible alert-success mb-4">
            <button type="button" class="close" data-dismiss="alert">&times;</button>
            <i class="fa fa-check-circle"></i> Item aggiornato con successo!
        </div>
    <?php } ?>
<?php } ?>

<!-- Breadcrumbs -->
<nav aria-label="breadcrumb" class="breadcrumb-modern mb-4">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="<?php print $shop_url; ?>"><i class="fa fa-home"></i> Home</a></li>
        <li class="breadcrumb-item"><a href="<?php print $shop_url.'category/'.$item[0]['category'].'/'; ?>"><i class="fa fa-tag"></i> <?php print is_get_category_name($item[0]['category']); ?></a></li>
        <li class="breadcrumb-item active"><i class="fa fa-cube"></i> <?php if(!$item_name_db) print $item_name = get_item_name($item[0]['vnum']); else print $item_name = get_item_name_locale_name($item[0]['vnum']); ?></li>
    </ol>
</nav>

<!-- MAIN ITEM DISPLAY (The "Above the Fold" Section) -->
<div class="item-main-display mb-4">
    <div class="row">
        <!-- Left: Image -->
        <div class="col-md-4 mb-3 mb-md-0">
            <div class="card border-secondary mb-3" style="background: rgba(0,0,0,0.2);">
                <div class="card-body text-center p-4">
                    <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum']); ?>.png" 
                         class="img-fluid" 
                         style="max-height: 200px; filter: drop-shadow(0 5px 15px rgba(0,0,0,0.3));">
                </div>
            </div>
        </div>

        <!-- Right: Info -->
        <div class="col-md-8" style="position: relative; z-index: 5;">
            <h2 class="item-detail-title mt-0" style="font-family: var(--font-title); color: #fff; font-size: 2rem; margin-bottom: 15px; border-bottom: 1px solid rgba(255,255,255,0.1); padding-bottom: 10px;">
                <?php print $item_name; ?>
            </h2>
            
            <!-- Price Section -->
            <div class="item-detail-price mb-4 p-3" style="background: rgba(255,255,255,0.05); border-radius: 8px; border-left: 4px solid var(--gold-accent);">
                <?php if($item[0]['discount']>0) { 
                    $discount_expire = date("Y-m-d H:i:s", $item[0]['discount_expire']);
                ?>
                    <div class="d-flex align-items-center mb-1">
                        <span class="badge badge-danger mr-2">-<?php print $item[0]['discount']; ?>%</span>
                        <span class="old-price mr-2" style="font-size: 1.2rem; text-decoration: line-through; color: #888;"><?php print $price1; ?> MD</span>
                    </div>
                    <div class="d-flex align-items-center justify-content-between">
                        <span class="current-price" style="font-size: 2.2rem; color: var(--gold-accent); font-weight: bold;"><?php print $total; ?> MD</span>
                        <small class="text-danger font-weight-bold" data-countdown="<?php print $discount_expire; ?>"></small>
                    </div>
                <?php } else { ?>
                    <span class="current-price" style="font-size: 2.2rem; color: var(--gold-accent); font-weight: bold;"><?php print $price1; ?> MD</span>
                <?php } ?>
            </div>

            <!-- Quick Stats -->
            <div class="item-quick-stats mb-4">
                <?php if($item[0]['count']>1) { ?>
                    <span class="badge badge-dark border border-secondary p-2 mr-2 mb-2"><i class="fa fa-cubes"></i> x<?php print $item[0]['count']; ?></span>
                <?php } ?>
                
                <?php $lvl = get_item_lvl($item[0]['vnum']); if($lvl) { ?>
                    <span class="badge badge-dark border border-secondary p-2 mr-2 mb-2"><i class="fa fa-level-up"></i> Liv. <?php print $lvl; ?></span>
                <?php } ?>
                
                <?php if(check_item_sash($item[0]['vnum'])) { ?>
                    <span class="badge badge-dark border border-secondary p-2 mr-2 mb-2"><i class="fa fa-shield"></i> <?php print is_get_sash_absorption($get_item); ?>%</span>
                <?php } ?>

                <?php if($item[0]['item_unique']==1 || $item[0]['item_unique']==2) { ?>
                    <span class="badge badge-dark border border-secondary p-2 mr-2 mb-2"><i class="fa fa-clock-o"></i> <?php is_get_item_time($get_item); ?></span>
                <?php } ?>
            </div>

            <!-- Buy & Wishlist Buttons -->
            <?php if(is_loggedin()) { 
                require_once __DIR__ . '/../../include/functions/wishlist.php';
                $in_wishlist = wishlist_has(get_account_id(), $get_item);
            ?>
                <div style="position: relative; z-index: 50; display: flex; gap: 10px;">
                    <button type="button" class="btn btn-primary btn-lg px-4" 
                            data-toggle="modal" data-target="#buyModal"
                            <?php if(is_coins(0)<$total) print 'disabled'; ?>>
                        <i class="fa fa-shopping-cart"></i> <?php print $lang_shop['buy']; ?>
                    </button>
                    
                    <?php if($in_wishlist) { ?>
                        <a href="<?php print $shop_url; ?>wishlist?action=remove&item_id=<?php print $get_item; ?>" class="btn btn-outline-danger btn-lg px-3" title="Rimuovi dai preferiti">
                            <i class="fa fa-heart"></i>
                        </a>
                    <?php } else { ?>
                        <a href="<?php print $shop_url; ?>wishlist?action=add&item_id=<?php print $get_item; ?>&vnum=<?php print $item[0]['vnum']; ?>&name=<?php print urlencode($item_name); ?>&price=<?php print $total; ?>" class="btn btn-outline-secondary btn-lg px-3" title="Aggiungi ai preferiti">
                            <i class="fa fa-heart-o"></i>
                        </a>
                    <?php } ?>
                </div>
                <?php if(is_coins(0)<$total) { ?>
                    <div class="mt-2 text-danger"><i class="fa fa-exclamation-circle"></i> Saldo insufficiente</div>
                <?php } ?>
            <?php } else { ?>
                <div class="alert alert-warning">
                    <i class="fa fa-lock"></i> <?php print $lang_shop['authentication_required']; ?> <a href="<?php print $shop_url; ?>login" class="alert-link">Accedi</a>
                </div>
            <?php } ?>
        </div>
    </div>
</div>

<!-- Description & Bonuses -->
<div class="row">
    <div class="col-md-12">
        <!-- Description -->
        <?php if(($item[0]['type']!=3) || ($item[0]['type']==3 && $item[0]['description'])) { ?>
        <div class="card mb-4" style="background: rgba(20,20,20,0.6); border: 1px solid var(--glass-border);">
            <div class="card-header" style="background: rgba(255,255,255,0.05); border-bottom: 1px solid var(--glass-border);">
                <h4 class="m-0" style="color: var(--scarlet-primary); font-family: var(--font-title);"><i class="fa fa-info-circle"></i> <?php print $lang_shop['description']; ?></h4>
            </div>
            <div class="card-body">
                <p class="card-text" style="color: #ccc; font-size: 1.1rem; line-height: 1.6;">
                    <?php 
                    if($item[0]['description']) {
                        // Fix for layout bug: Strip block-level tags that might be unclosed in DB
                        // Allow only safe inline tags
                        print nl2br(strip_tags($item[0]['description'], '<p><br><b><strong><i><em><a><ul><li><span><font>')); 
                    } else {
                        print $lang_shop['no_description']; 
                    }
                    ?>
                </p>
            </div>
        </div>
        <?php } ?>

        <!-- Bonus Selection (Type 3) -->
        <?php if($item[0]['type']==3) { ?>
        <div class="card mb-4 border-success" style="background: rgba(20,20,20,0.6); transform: none !important; transition: none !important;">
            <div class="card-header bg-success text-white">
                <h4 class="m-0"><i class="fa fa-star"></i> <?php print $lang_shop['bonus_selection']; ?></h4>
            </div>
            <div class="card-body">
                <div class="form-group">
                    <?php for($i=0;$i<$count;$i++) { ?>
                        <select onChange="use(this)" class="form-control select-spacing mb-3" name="attrtype<?php print $i ?>" id="attrtype<?php print $i ?>" form="buy_item" required style="background: rgba(0,0,0,0.5); color: #fff; border: 1px solid #444;">
                            <option value="" selected="selected"><?php print $lang_shop['bonus_selection'].' #'.$i; ?></option>
                            <?php foreach($available_bonuses as $key => $bonus) { ?>
                            <option value="<?php print $key; ?>"><?php print str_replace("[n]", $bonus, $bonuses_name[$key]); ?></option>
                            <?php } ?>
                        </select>
                    <?php } ?>
                </div>
            </div>
        </div>
        <?php } ?>
        
        <!-- Bonus Item Section -->
		<?php
			$item_bonuses = get_item_bonuses($get_item);
            $proto_bonuses = get_item_proto_bonuses($item[0]['vnum']);
            
			if(count($item_bonuses) > 0 || count($proto_bonuses) > 0) {
		?>
		<div class="item-bonuses-section mt-4 mb-4">
			<h3 class="section-title mb-3" style="color: #fff; font-family: var(--font-title);">
				<i class="fa fa-magic"></i> Bonus Item
			</h3>
			<div class="card" style="background: rgba(20,20,20,0.6); border: 1px solid var(--glass-border);">
				<div class="card-body">
					<div class="row">
                        <!-- Base Bonuses (Proto) -->
                        <?php foreach($proto_bonuses as $bonus) { ?>
						<div class="col-md-6 col-lg-4 mb-3">
							<div class="bonus-item" style="display: flex; align-items: center; padding: 10px; background: rgba(255,255,255,0.05); border-radius: 10px; border-left: 3px solid #aaa;">
								<i class="fa fa-shield bonus-icon mr-2" style="color: #aaa;"></i>
								<span class="bonus-name mr-auto" style="color: #ddd;"><?php echo htmlspecialchars($bonus['name']); ?></span>
								<span class="bonus-value font-weight-bold" style="color: #fff;"><?php echo htmlspecialchars($bonus['formatted_value']); ?></span>
							</div>
						</div>
						<?php } ?>

                        <!-- Shop Bonuses (Custom) -->
						<?php foreach($item_bonuses as $bonus) { ?>
						<div class="col-md-6 col-lg-4 mb-3">
							<div class="bonus-item" style="display: flex; align-items: center; padding: 10px; background: rgba(255,255,255,0.05); border-radius: 10px; border-left: 3px solid var(--scarlet-primary);">
								<i class="fa fa-check-circle bonus-icon mr-2" style="color: var(--scarlet-primary);"></i>
								<span class="bonus-name mr-auto" style="color: #ddd;"><?php echo htmlspecialchars($bonus['name']); ?></span>
								<span class="bonus-value font-weight-bold" style="color: var(--gold-accent);"><?php echo htmlspecialchars($bonus['formatted_value']); ?></span>
							</div>
						</div>
						<?php } ?>
					</div>
				</div>
			</div>
		</div>
		<?php } ?>
    </div>
</div>

<!-- Related Items -->
<?php
    $related_items = is_get_related_items($item[0]['category'], $get_item, 8); // Increased to 8 items (2 rows)
    if(count($related_items) > 0) {
?>
<div class="related-items-section mt-5">
    <h3 class="section-title mb-4" style="color: #fff; font-family: var(--font-title); border-bottom: 1px solid var(--scarlet-dark); padding-bottom: 10px;">
        <i class="fa fa-cubes"></i> Altri Item di <?php print is_get_category_name($item[0]['category']); ?>
    </h3>
    <div class="row">
        <?php foreach($related_items as $row) {
            $original_price = $row['coins'];
            $final_price = $row['discount'] > 0 ? $row['coins'] - ($row['coins'] * $row['discount'] / 100) : $row['coins'];
            $r_item_name = !$item_name_db ? get_item_name($row['vnum']) : get_item_name_locale_name($row['vnum']);
        ?>
        <div class="col-lg-3 col-md-6 mb-4">
            <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" style="text-decoration: none;">
                <div class="card mb-3 text-center h-100" style="background: rgba(20,20,20,0.6); border: 1px solid var(--glass-border); transition: transform 0.3s; overflow: hidden;">
                    <div class="card-block p-3 d-flex flex-column h-100">
                        <!-- Badge Sconto -->
                        <?php if($row['discount']>0) { ?>
                        <span class="badge badge-danger font-weight-bold strong pull-right" style="position: absolute; top: 10px; right: 10px; z-index: 10;">- <?php print $row['discount']; ?>%</span>
                        <?php } ?>

                        <!-- Image -->
                        <div class="min-image-item mb-3 mt-2 d-flex align-items-center justify-content-center" style="height: 160px;">
                            <img class="image-item img-fluid" 
                                 src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum']); ?>.png" 
                                 alt="<?php print $r_item_name; ?>"
                                 style="max-height: 140px; max-width: 100%; filter: drop-shadow(0 5px 15px rgba(0,0,0,0.3)); transition: transform 0.3s;">
                        </div>
                        
                        <!-- Title -->
                        <div class="item-name-truncate mb-2" style="color: #fff; font-weight: 600; font-size: 1.1rem; min-height: 3em; display: flex; align-items: center; justify-content: center;">
                            <?php print $r_item_name; ?>
                        </div>

                        <!-- Price -->
                        <div class="item-price-tag mt-auto">
                            <?php if($row['discount'] > 0) { ?>
                                <div class="d-flex justify-content-center align-items-center gap-2">
                                    <span class="old-price mr-2" style="font-size: 0.9rem; text-decoration: line-through; color: #888;"><?php echo $row['coins']; ?> MD</span>
                                    <span class="current-price" style="font-size: 1.3rem; color: var(--gold-accent); font-weight: bold;"><?php echo round($final_price); ?> MD</span>
                                </div>
                            <?php } else { ?>
                                <span class="current-price" style="font-size: 1.3rem; color: var(--gold-accent); font-weight: bold;"><?php echo $final_price; ?> MD</span>
                            <?php } ?>
                        </div>
                    </div>
                </div>
            </a>
        </div>
        <?php } ?>
    </div>
    
    <!-- View All Button -->
    <div class="row">
        <div class="col-12 text-center mt-2 mb-4">
            <a href="<?php print $shop_url.'category/'.$item[0]['category'].'/'; ?>" class="btn btn-secondary" style="background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.2); color: #fff; padding: 12px 40px; border-radius: 50px; transition: all 0.3s; font-weight: 600; text-transform: uppercase; letter-spacing: 1px;">
                <i class="fa fa-th"></i> Visualizza tutti gli item della categoria
            </a>
        </div>
    </div>
</div>
<?php } ?>

<!-- Edit Item Modal -->
<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<!-- Summernote for WYSIWYG editing -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote-bs4.min.js"></script>
<style>
    /* Summernote Dark Theme Fixes */
    .note-editor.note-frame { border: 1px solid #444 !important; background: #222 !important; }
    .note-editor.note-frame .note-editing-area .note-editable { color: #ddd !important; background: #222 !important; }
    .note-toolbar { background: #333 !important; border-bottom: 1px solid #444 !important; }
    .note-btn { background: #444 !important; color: #ddd !important; border: 1px solid #555 !important; }
    .note-btn:hover { background: #555 !important; color: #fff !important; }
    .note-icon-caret { color: #ddd; }
    .note-popover { display: none !important; } /* Hide popovers to avoid z-index issues */
</style>

<div class="modal fade" id="editItemModal" tabindex="-1" role="dialog" aria-labelledby="editItemModalLabel" aria-hidden="true" style="z-index: 10500;">
    <div class="modal-dialog modal-lg modal-dialog-centered" role="document">
        <div class="modal-content" style="background: #1a1a1a; border: 1px solid var(--scarlet-primary); color: #fff;">
            <div class="modal-header" style="border-bottom: 1px solid #333;">
                <h5 class="modal-title" id="editItemModalLabel"><i class="fa fa-pencil"></i> Modifica Item</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: #fff;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form action="" method="post" id="edit_item_form">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Vnum (ID Oggetto)</label>
                                <input type="number" class="form-control" name="edit_vnum" value="<?php echo $item[0]['vnum']; ?>" required style="background: #222; border: 1px solid #444; color: #fff;">
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="form-group">
                                <label>Quantità</label>
                                <input type="number" class="form-control" name="edit_count" value="<?php echo $item[0]['count']; ?>" required style="background: #222; border: 1px solid #444; color: #fff;">
                            </div>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label>Prezzo (Monete)</label>
                        <input type="number" class="form-control" name="edit_coins" value="<?php echo $item[0]['coins']; ?>" required style="background: #222; border: 1px solid #444; color: #fff;">
                    </div>
                    
                    <div class="form-group">
                        <label>Descrizione</label>
                        <textarea class="form-control" name="edit_description" id="edit_description" rows="5"><?php echo htmlspecialchars($item[0]['description']); ?></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer" style="border-top: 1px solid #333;">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Annulla</button>
                <button type="submit" form="edit_item_form" name="edit_item" class="btn btn-warning">Salva Modifiche</button>
            </div>
        </div>
    </div>
</div>
<script>
    // Move modal to body to prevent z-index issues
    document.addEventListener("DOMContentLoaded", function() {
        var editModal = document.getElementById('editItemModal');
        if (editModal) {
            document.body.appendChild(editModal);
            
            // Initialize Summernote
            $('#edit_description').summernote({
                height: 200,
                dialogsInBody: true,
                toolbar: [
                    ['style', ['bold', 'italic', 'underline', 'clear']],
                    ['font', ['strikethrough', 'superscript', 'subscript']],
                    ['fontsize', ['fontsize']],
                    ['color', ['color']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['height', ['height']],
                    ['view', ['codeview']]
                ]
            });
        }
    });
</script>
<?php } ?>

<!-- Modal Confirmation (Rebuilt from scratch) -->
<?php if(is_loggedin()) { ?>
<div class="modal fade" id="buyModal" tabindex="-1" role="dialog" aria-labelledby="buyModalLabel" aria-hidden="true" style="z-index: 10500;">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content" style="background: #1a1a1a; border: 1px solid var(--scarlet-primary); color: #fff; box-shadow: 0 0 20px rgba(0,0,0,0.8);">
            <div class="modal-header" style="border-bottom: 1px solid #333;">
                <h5 class="modal-title" id="buyModalLabel" style="font-family: var(--font-title); color: var(--scarlet-primary); font-size: 1.2rem;">
                    <i class="fa fa-shopping-cart"></i> Conferma Acquisto
                </h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="color: #fff; opacity: 0.8; text-shadow: none;">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body text-center p-4">
                <p style="font-size: 1.1rem; margin-bottom: 20px; color: #ddd;"><?php print $lang_shop['sure']; ?></p>
                
                <div style="background: rgba(255,255,255,0.05); padding: 15px; border-radius: 8px; border: 1px solid #333;">
                    <p class="text-muted mb-1" style="font-size: 0.9rem; text-transform: uppercase; letter-spacing: 1px;">Prezzo Totale</p>
                    <p style="font-size: 1.8rem; color: var(--gold-accent); font-weight: bold; margin: 0; text-shadow: 0 0 10px rgba(255, 215, 0, 0.3);">
                        <?php print $total; ?> MD
                    </p>
                </div>
            </div>
            <div class="modal-footer" style="border-top: 1px solid #333; padding: 15px;">
                <form action="" method="post" id="buy_item" style="width: 100%; display: flex; gap: 15px;">
                    <input type="hidden" name="buy_key" value="<?php echo $_SESSION['buy_key'] ?>">
                    
                    <button type="button" class="btn btn-secondary" data-dismiss="modal" style="flex: 1; padding: 10px;">
                        <?php print $lang_shop['no']; ?>
                    </button>
                    
                    <button type="submit" name="buy" class="btn btn-success" style="flex: 1; padding: 10px; background: linear-gradient(135deg, #27ae60 0%, #229954 100%); border: none; font-weight: bold; letter-spacing: 1px;">
                        <i class="fa fa-check"></i> <?php print $lang_shop['buy']; ?>
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
    // Vanilla JS to move modal to body (Fixes ReferenceError: $ is not defined)
    document.addEventListener("DOMContentLoaded", function() {
        var modal = document.getElementById('buyModal');
        if (modal) {
            document.body.appendChild(modal);
        }
    });
</script>
<?php } ?>