<!-- Widget Dettagli Oggetto Compatto -->
<div class="sidebar-item-widget">

    <!-- Header con Icona e Nome -->
    <div class="widget-item-header">
        <div class="widget-item-icon">
            <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum'], $item[0]['id']); ?>.png" alt="<?php print $item_name; ?>">
        </div>
        <div class="widget-item-title">
            <h4><?php print $item_name; ?></h4>
            <!-- Badge Inline -->
            <?php if($item[0]['discount'] > 0 || $item[0]['expire'] > 0 || $item[0]['count'] > 1) { ?>
            <div class="widget-badges">
                <?php if($item[0]['discount'] > 0) { ?>
                <span class="badge-xs badge-green"><i class="fas fa-tag"></i> -<?php print $item[0]['discount']; ?>%</span>
                <?php } ?>
                <?php if($item[0]['expire'] > 0) {
                    $promo_expire = date("Y-m-d H:i:s", $item[0]['expire']);
                ?>
                <span class="badge-xs badge-red countdown-timer" data-countdown="<?php print $promo_expire; ?>"><i class="fas fa-clock"></i></span>
                <?php } ?>
                <?php if($item[0]['count'] > 1) { ?>
                <span class="badge-xs badge-blue"><i class="fas fa-layer-group"></i> <?php print $item[0]['count']; ?>x</span>
                <?php } ?>
            </div>
            <?php } ?>
        </div>
    </div>

    <!-- Stats Compatte -->
    <div class="widget-stats">
        <ul>
            <?php 
            $lvl = get_item_lvl($item[0]['vnum']);
            if($lvl) { 
            ?>
            <li>
                <i class="fas fa-star"></i>
                <span>Livello <?php print $lvl; ?></span>
            </li>
            <?php } ?>
            
            <?php if($item[0]['count'] > 1) { ?>
            <li>
                <i class="fas fa-layer-group"></i>
                <span>Quantità: <?php print $item[0]['count']; ?>x</span>
            </li>
            <?php } ?>

            <?php if($item[0]['item_unique'] == 1 || $item[0]['item_unique'] == 2) { ?>
            <li>
                <i class="fas fa-hourglass-half"></i>
                <span><?php is_get_item_time($get_item); ?></span>
            </li>
            <?php } ?>

            <?php if(check_item_sash($item[0]['vnum'])) { ?>
            <li>
                <i class="fas fa-shield-alt"></i>
                <span>Assorbimento: <?php print is_get_sash_absorption($get_item); ?>%</span>
            </li>
            <?php } ?>

            <?php 
            is_get_item($get_item); 
            if(check_item_sash($item[0]['vnum'])) {
                is_get_sash_bonuses($get_item);
            }
            if(get_item_name($item[0]['socket0'])) {
                get_item_stones_market($get_item);
            }
            ?>
        </ul>
    </div>
    
    <!-- Prezzo e Azione -->
    <div class="widget-footer">
        <?php if(is_loggedin()) { ?>
        <div class="widget-price">
            <img src="<?php print $shop_url; ?>images/<?php print ($item[0]['pay_type']==1) ? 'monet' : 'jd'; ?>.png" alt="MD">
            <div class="price-info">
                <span class="price-main"><?php print number_format($total, 0, '', ','); ?></span>
                <?php if($item[0]['discount'] > 0) { ?>
                <span class="price-old"><?php print number_format($price1, 0, '', ','); ?></span>
                <?php } ?>
            </div>
        </div>
        <?php } else { ?>
        <div class="widget-login">
            <i class="fas fa-lock"></i>
            <span>Login richiesto</span>
        </div>
        <?php } ?>
    </div>

</div>