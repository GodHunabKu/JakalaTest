<?php if(is_loggedin() && web_admin_level()>=9) { ?>
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

<div class="shop-content-wrapper">
    <!-- Page Header -->
    <div class="page-header">
        <div class="page-title">
            <i class="fas fa-shopping-bag"></i>
            <h1><?php print is_get_category_name($get_category); ?></h1>
        </div>
        <div class="page-breadcrumb">
            <a href="<?php print $shop_url; ?>">Home</a>
            <i class="fas fa-chevron-right"></i>
            <span><?php print is_get_category_name($get_category); ?></span>
        </div>
    </div>

    <?php if(!is_loggedin()) { ?>
    <!-- Login Notice for Guests -->
    <div class="guest-notice">
        <i class="fas fa-lock"></i>
        <h3>Login to see prices and purchase</h3>
        <p>Create an account or login to view item prices and make purchases</p>
        <a href="<?php print $shop_url; ?>login" class="btn-notice-login">
            <i class="fas fa-sign-in-alt"></i>
            <span>Login Now</span>
        </a>
    </div>
    <?php } ?>

    <!-- Items Grid -->
    <div class="items-grid">
        <?php
        $list = array();
        $list = is_items_list($get_category);
        
        if(!count($list)) {
            echo '<div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>No items found</h3>
                    <p>This category is currently empty.</p>
                  </div>';
        } else {
            foreach($list as $row) {
        ?>
        <a href="<?php print $shop_url.'item/'.$row['id'].'/'; ?>" class="item-card <?php if(!is_loggedin()) print 'item-card-locked'; ?>">
            <div class="item-card-inner">
                <?php if(is_loggedin() && web_admin_level()>=9) { ?>
                <!-- Admin Edit Button -->
                <a href="<?php print $shop_url.'edit/item/'.$row['id'].'/'; ?>" class="item-edit-btn" onclick="event.stopPropagation(); event.preventDefault(); window.location.href=this.href;">
                    <i class="fas fa-edit"></i>
                    <span>Edit</span>
                </a>
                <?php } ?>

                <!-- Item Image -->
                <div class="item-image-wrapper">
                    <?php if(!is_loggedin()) { ?>
                    <!-- Lock Overlay for Guests -->
                    <div class="item-lock-overlay">
                        <i class="fas fa-lock"></i>
                        <span>Login to view</span>
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
                        <img src="<?php print $shop_url; ?>images/<?php print ($row['pay_type']==1) ? 'md' : 'jd'; ?>.png" alt="Coins">
                        <span><?php print number_format($row['price'], 0, '', ','); ?></span>
                    </div>
                    <?php } else { ?>
                    <!-- Login prompt for guests -->
                    <div class="item-login-required">
                        <i class="fas fa-lock"></i>
                        <span>Login to view price</span>
                    </div>
                    <?php } ?>
                    
                    <div class="item-action">
                        <span><?php print is_loggedin() ? 'View Details' : 'Login to purchase'; ?></span>
                        <i class="fas fa-arrow-right"></i>
                    </div>
                </div>
            </div>
        </a>
        <?php } } ?>
    </div>
</div>