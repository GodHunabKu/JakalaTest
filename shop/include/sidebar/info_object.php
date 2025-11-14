<!-- Card Principale Dettagli Oggetto -->
<div class="item-details-main-card">

    <!-- Sezione Showcase: Immagine e Nome -->
    <div class="item-showcase">
        <div class="showcase-image-wrapper">
            <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum']); ?>.png" alt="<?php print $item_name; ?>">
        </div>
        <h3 class="showcase-name"><?php print $item_name; ?></h3>
    </div>

    <!-- Sezione Badge: Sconti e Timer Promozioni -->
    <div class="item-badges-container">
        <?php if($item[0]['discount'] > 0) {
            $discount_expire = date("Y-m-d H:i:s", $item[0]['discount_expire']);
        ?>
            <div class="item-badge badge-discount">
                <i class="fas fa-percentage"></i>
                <span>Sconto del <?php print $item[0]['discount']; ?>%</span>
                <small class="countdown-timer" data-countdown="<?php print $discount_expire; ?>"></small>
            </div>
        <?php } ?>
        <?php if($item[0]['expire'] > 0) {
            $promo_expire = date("Y-m-d H:i:s", $item[0]['expire']);
        ?>
            <div class="item-badge badge-timer">
                <i class="fas fa-fire"></i>
                <span>Offerta a tempo</span>
                <small class="countdown-timer" data-countdown="<?php print $promo_expire; ?>"></small>
            </div>
        <?php } ?>
    </div>

    <!-- Sezione Statistiche e Bonus -->
    <div class="item-stats-section">
        <ul class="stats-list">
            <?php if($item[0]['count'] > 1) { ?>
                <li>
                    <span class="stat-label"><i class="fas fa-layer-group"></i> Quantit�</span>
                    <span class="stat-value"><?php print $item[0]['count']; ?> unit�</span>
                </li>
            <?php } ?>

            <?php 
                $lvl = get_item_lvl($item[0]['vnum']);
                if($lvl) { 
            ?>
                <li>
                    <span class="stat-label"><i class="fas fa-gavel"></i> Livello Richiesto</span>
                    <span class="stat-value">Lv. <?php print $lvl; ?></span>
                </li>
            <?php } ?>
            
            <?php if($item[0]['item_unique'] == 1 || $item[0]['item_unique'] == 2) { ?>
                <li>
                    <span class="stat-label"><i class="fas fa-hourglass-half"></i> Durata Oggetto</span>
                    <span class="stat-value"><?php is_get_item_time($get_item); ?></span>
                </li>
            <?php } ?>

            <?php if(check_item_sash($item[0]['vnum'])) { ?>
                <li>
                    <span class="stat-label"><i class="fas fa-shield-alt"></i> Assorbimento Bonus</span>
                    <span class="stat-value"><?php print is_get_sash_absorption($get_item); ?>%</span>
                </li>
            <?php } ?>

            <!-- Le seguenti funzioni probabilmente stampano gi� del codice HTML.
                 Potrebbe essere necessario adattare il loro output per integrarsi
                 perfettamente con lo stile della lista (es. farle stampare <li>). -->
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
    
    <!-- Sezione Azioni: Prezzo e Acquisto -->
    <div class="item-action-footer">
        <?php if(is_loggedin()) { ?>
            <div class="item-final-price">
                <img src="<?php print $shop_url; ?>images/md.png" alt="MD Coins">
                <div class="price-details">
                    <span class="current-price">
                        <?php print number_format($total); ?>
                        <small>MD</small>
                    </span>
                    <?php if($item[0]['discount'] > 0) { ?>
                        <span class="original-price"><?php print number_format($price1); ?></span>
                    <?php } ?>
                </div>
            </div>
            
            <button type="button" class="btn-purchase-main" <?php if(is_coins($item[0]['pay_type']-1) < $total) print 'disabled'; ?> data-toggle="modal" data-target="#myModal">
                <i class="fas fa-shopping-cart"></i>
                <span><?php print (is_coins($item[0]['pay_type']-1) < $total) ? 'Fondi Insufficienti' : $lang_shop['buy']; ?></span>
            </button>
        <?php } else { ?>
            <div class="login-prompt">
                <i class="fas fa-lock"></i>
                <span><?php print $lang_shop['authentication_required']; ?></span>
            </div>
        <?php } ?>
    </div>
</div>