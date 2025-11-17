<?php
// Validazione e caricamento dati item
if (!isset($get_item) || !is_numeric($get_item)) {
    redirect($shop_url);
}

$item = is_item_select($get_item);
if (!count($item)) {
    redirect($shop_url);
}

// Calcolo prezzo con sconto
$price1 = $item[0]['coins'];
if ($item[0]['discount'] > 0) {
    $total = $item[0]['coins'] - ($item[0]['coins'] * $item[0]['discount'] / 100);
} else {
    $total = $item[0]['coins'];
}

// Bonus selection items
if ($item[0]['type'] == 3) {
    $bonuses = is_get_bonus_selection($get_item);
    $bonuses_name = is_get_bonuses_new_name();
    $count = 0;
    $available_bonuses = array();
    foreach ($bonuses as $key => $bonus) {
        if ($key[0] == 'b' && $bonus > 0) {
            $count++;
            $available_bonuses[intval(str_replace("bonus", "", $key))] = $bonus;
        }
    }
}

// Process purchase
if(is_loggedin() && isset($_POST['buy']) && isset($_POST['buy_key']) && $_POST['buy_key'] == $_SESSION['buy_key']) {
    if($total <= is_coins($item[0]['pay_type'] - 1)) {
        if (is_buy_item($get_item, [])) {
            is_pay_coins($item[0]['pay_type'] - 1, $total);
            $_SESSION['purchase_success'] = true;
            redirect($shop_url.'item/'.$get_item.'/');
        } else {
            $_SESSION['purchase_error'] = 'space';
        }
    } else {
        $_SESSION['purchase_error'] = 'funds';
    }
}

// Generate new buy key
if(!isset($_SESSION['buy_key'])) {
    $_SESSION['buy_key'] = mt_rand(1, 1000000);
}
?>

<!-- Admin Actions -->
<?php if(is_loggedin() && web_admin_level()>=9) { ?>
<div class="admin-bar">
    <a href="<?php print $shop_url.'edit/item/'.$get_item.'/'; ?>" class="btn-admin-sm"><i class="fas fa-edit"></i> Modifica</a>
    <a href="<?php print $shop_url.'remove/item/'.$get_item.'/'.$item[0]['category'].'/'; ?>" class="btn-admin-sm btn-danger" onclick="return confirm('Eliminare?')"><i class="fas fa-trash"></i> Elimina</a>
</div>
<?php } ?>

<!-- Alerts -->
<?php
if(isset($_SESSION['purchase_success'])) {
    echo '<div class="alert-compact alert-success"><i class="fas fa-check-circle"></i> Acquisto completato!</div>';
    unset($_SESSION['purchase_success']);
}
if(isset($_SESSION['purchase_error'])) {
    $msg = $_SESSION['purchase_error']=='space' ? 'Spazio insufficiente!' : 'Fondi insufficienti!';
    echo '<div class="alert-compact alert-danger"><i class="fas fa-exclamation-triangle"></i> '.$msg.'</div>';
    unset($_SESSION['purchase_error']);
}
?>

<!-- Item Grid Compact -->
<div class="item-grid-compact">

    <!-- Main Card -->
    <div class="item-main-card">
        <div class="item-header-row">
            <div class="item-icon-box">
                <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum'], $item[0]['id']); ?>.png" alt="<?php print $item_name; ?>">
            </div>
            <div class="item-title-box">
                <h1 class="item-name"><?php print $item_name; ?></h1>
                <div class="item-badges-inline">
                    <?php if($item[0]['discount'] > 0) { ?>
                    <span class="badge-inline badge-green"><i class="fas fa-tag"></i> -<?php print $item[0]['discount']; ?>%</span>
                    <?php } ?>
                    <?php if($item[0]['expire'] > 0) {
                        $promo_expire = date("Y-m-d H:i:s", $item[0]['expire']);
                    ?>
                    <span class="badge-inline badge-red countdown-timer" data-countdown="<?php print $promo_expire; ?>"><i class="fas fa-clock"></i></span>
                    <?php } ?>
                    <?php if($item[0]['count'] > 1) { ?>
                    <span class="badge-inline badge-blue"><i class="fas fa-layer-group"></i> <?php print $item[0]['count']; ?>x</span>
                    <?php } ?>
                </div>
            </div>
            <div class="item-price-box">
                <?php if($item[0]['discount'] > 0) { ?>
                <div class="price-old"><?php print number_format($price1, 0, '', ','); ?></div>
                <?php } ?>
                <div class="price-current">
                    <img src="<?php print $shop_url; ?>images/<?php print ($item[0]['pay_type']==1) ? 'monet' : 'jd'; ?>.png" alt="MD">
                    <span><?php print number_format($total, 0, '', ','); ?></span>
                </div>
            </div>
            <div class="item-action-box">
                <?php if(is_loggedin()) { ?>
                <form id="buy_item_form" action="" method="post" style="margin: 0;">
                    <?php echo csrf_field(); ?>
                    <input type="hidden" name="buy_key" value="<?php print $_SESSION['buy_key']; ?>">
                    <button type="submit" name="buy" class="btn-buy-compact" <?php if(is_coins($item[0]['pay_type']-1) < $total) print 'disabled'; ?>>
                        <i class="fas fa-shopping-cart"></i> <?php print (is_coins($item[0]['pay_type']-1) < $total) ? 'Insufficienti' : 'Acquista'; ?>
                    </button>
                </form>
                <?php if(is_coins($item[0]['pay_type']-1) < $total && is_paypal_list()) { ?>
                <a href="<?php print $shop_url; ?>buy/coins" class="btn-recharge-compact"><i class="fas fa-plus-circle"></i> Ricarica</a>
                <?php } ?>
                <?php } else { ?>
                <a href="<?php print $shop_url; ?>login" class="btn-buy-compact"><i class="fas fa-lock"></i> Login</a>
                <?php } ?>
            </div>
        </div>

        <?php if(!empty($item[0]['description'])) { ?>
        <div class="item-description-row">
            <strong><i class="fas fa-align-left"></i> Descrizione:</strong>
            <p><?php print nl2br(htmlspecialchars($item[0]['description'])); ?></p>
        </div>
        <?php } ?>

        <div class="item-stats-row">
            <strong><i class="fas fa-chart-line"></i> Statistiche:</strong>
            <ul class="stats-list-compact">
                <?php
                $lvl = get_item_lvl($item[0]['vnum']);
                if($lvl) echo '<li><i class="fas fa-star"></i> Livello: <span>Lv. '.$lvl.'</span></li>';
                if($item[0]['count'] > 1) echo '<li><i class="fas fa-layer-group"></i> Quantit�: <span>'.$item[0]['count'].'x</span></li>';
                if($item[0]['item_unique'] == 1 || $item[0]['item_unique'] == 2) {
                    echo '<li><i class="fas fa-hourglass-half"></i> Durata: <span>';
                    is_get_item_time($get_item);
                    echo '</span></li>';
                }
                if(check_item_sash($item[0]['vnum'])) {
                    echo '<li><i class="fas fa-shield-alt"></i> Assorbimento: <span>'.is_get_sash_absorption($get_item).'%</span></li>';
                }
                is_get_item($get_item);
                if(check_item_sash($item[0]['vnum'])) is_get_sash_bonuses($get_item);
                if(get_item_name($item[0]['socket0'])) get_item_stones_market($get_item);
                if(is_loggedin() && web_admin_level()>=9) echo '<li style="color: var(--one-scarlet);"><i class="fas fa-code"></i> VNUM: <span>'.$item[0]['vnum'].'</span></li>';
                ?>
            </ul>
        </div>
    </div>

</div>