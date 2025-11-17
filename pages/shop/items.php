<?php if(is_loggedin() && web_admin_level()>=9 && $get_category > 0) { ?>
<div class="admin-actions-bar">
    <a href="<?php print $shop_url.'add/item/'.$get_category.'/'; ?>" class="btn-admin btn-admin-info">
        <i class="fas fa-plus-circle"></i>
        <span><?php print $lang_shop['is_add_items']; ?></span>
    </a>
    <a href="<?php print $shop_url.'add/bonus/item/'.$get_category.'/'; ?>" class="btn-admin btn-admin-danger">
        <i class="fas fa-star"></i>
        <span><?php print $lang_shop['is_add_items'].' ['.$lang_shop['bonus_selection'].']'; ?></span>
    </a>
</div>
<?php } ?>
<?php if(is_loggedin() && web_admin_level()>=9 && $get_category == 0) { ?>
<div class="admin-actions-bar">
    <div class="alert-message alert-info">
        <i class="fas fa-info-circle"></i>
        <span>Seleziona una categoria specifica per aggiungere nuovi oggetti</span>
    </div>
</div>
<?php } ?>

<div class="shop-content-wrapper">
    <!-- Page Header -->
    <div class="page-header">
        <div class="page-title">
            <i class="fas fa-shopping-bag"></i>
            <h1><?php print ($get_category == 0) ? 'Tutti gli Oggetti' : is_get_category_name($get_category); ?></h1>
        </div>
        <div class="page-breadcrumb">
            <a href="<?php print $shop_url; ?>">Home</a>
            <i class="fas fa-chevron-right"></i>
            <span><?php print ($get_category == 0) ? 'Tutti gli Oggetti' : is_get_category_name($get_category); ?></span>
        </div>
    </div>

    <?php if(!is_loggedin()) { ?>
    <!-- Login Notice for Guests -->
    <div class="guest-notice">
        <i class="fas fa-lock"></i>
        <h3>Effettua il login per vedere i prezzi e acquistare</h3>
        <p>Crea un account o effettua il login per visualizzare i prezzi degli oggetti e fare acquisti</p>
        <a href="<?php print $shop_url; ?>login" class="btn-notice-login">
            <i class="fas fa-sign-in-alt"></i>
            <span>Accedi Ora</span>
        </a>
    </div>
    <?php } ?>

    <!-- Items Grid -->
    <div class="items-grid">
        <?php
        $list = array();
        // Se $get_category == 0, mostra tutti gli oggetti, altrimenti filtra per categoria
        $list = ($get_category == 0) ? is_all_items_list() : is_items_list($get_category);

        if(!count($list)) {
            echo '<div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Nessun oggetto trovato</h3>
                    <p>'.($get_category == 0 ? 'Non ci sono oggetti nello shop.' : 'Questa categoria è attualmente vuota.').'</p>
                  </div>';
        } else {
            foreach($list as $row) {
        ?>
        <div style="position: relative;">
            <?php if(is_loggedin() && web_admin_level()>=9) { ?>
            <!-- Admin Edit Button - FUORI dal link principale per evitare bug -->
            <a href="<?php print $shop_url.'edit/item/'.$row['id'].'/'; ?>" class="item-edit-btn" style="position: absolute; top: 10px; right: 10px; z-index: 10;">
                <i class="fas fa-edit"></i>
                <span>Modifica</span>
            </a>
            <?php } ?>

            <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="item-card <?php if(!is_loggedin()) print 'item-card-locked'; ?>">
                <div class="item-card-inner">

                <!-- Item Image -->
                <div class="item-image-wrapper">
                    <?php if(!is_loggedin()) { ?>
                    <!-- Lock Overlay for Guests -->
                    <div class="item-lock-overlay">
                        <i class="fas fa-lock"></i>
                        <span>Login per visualizzare</span>
                    </div>
                    <?php } ?>
                    
                    <div class="item-image">
                        <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($row['vnum'], $row['id']); ?>.png" alt="<?php if(!$item_name_db) print get_item_name($row['vnum']); else print get_item_name_locale_name($row['vnum']); ?>">
                    </div>
                    
                    <!-- Badges (visible only if logged in) -->
                    <?php if(is_loggedin()) { ?>
                        <?php if($row['discount']>0) { ?>
                        <div class="item-badge item-badge-discount">
                            <i class="fas fa-percentage"></i>
                            <span>-<?php print $row['discount']; ?>%</span>
                        </div>
                        <?php } ?>
                        
                        <?php if($row['type']==3) { ?>
                        <div class="item-badge item-badge-bonus">
                            <i class="fas fa-star"></i>
                            <span><?php print $lang_shop['bonus_selection']; ?></span>
                        </div>
                        <?php } ?>
                        
                        <?php if($row['expire']>0) {
                            $expire = date("Y-m-d H:i:s", $row['expire']);
                        ?>
                        <div class="item-badge item-badge-timer">
                            <i class="fas fa-clock"></i>
                            <span class="countdown-timer" data-countdown="<?php print $expire; ?>"></span>
                        </div>
                        <?php } ?>
                    <?php } ?>
                </div>
                
                <!-- Item Info -->
                <div class="item-info">
                    <h3 class="item-name"><?php if(!$item_name_db) print get_item_name($row['vnum']); else print get_item_name_locale_name($row['vnum']); ?></h3>
                    
                    <?php if(is_loggedin()) { ?>
                    <!-- Price visible only when logged in -->
                    <div class="item-price">
                        <img src="<?php print $shop_url; ?>images/<?php print ($row['pay_type']==1) ? 'monet' : 'jd'; ?>.png" alt="Coins">
                        <span><?php print number_format($row['coins'], 0, '', ','); ?></span>
                    </div>
                    <?php } else { ?>
                    <!-- Login prompt for guests -->
                    <div class="item-login-required">
                        <i class="fas fa-lock"></i>
                        <span>Login per vedere il prezzo</span>
                    </div>
                    <?php } ?>

                    <div class="item-action">
                        <span><?php print is_loggedin() ? 'Vedi Dettagli' : 'Login per acquistare'; ?></span>
                        <i class="fas fa-arrow-right"></i>
                    </div>
                </div>
            </div>
        </a>
        </div>
        <?php } } ?>
    </div>
</div>