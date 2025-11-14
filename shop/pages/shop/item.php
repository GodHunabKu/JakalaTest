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
?>

<div class="shop-content-wrapper">

    <!-- Admin Actions Bar -->
    <?php if(is_loggedin() && web_admin_level()>=9) { ?>
    <div class="admin-actions-bar">
        <a href="<?php print $shop_url.'edit/item/'.$get_item.'/'; ?>" class="btn-admin btn-admin-info">
            <i class="fas fa-edit"></i>
            <span>Modifica Oggetto</span>
        </a>
        <a href="<?php print $shop_url.'remove/item/'.$get_item.'/'.$item[0]['category'].'/'; ?>" class="btn-admin btn-admin-danger" onclick="return confirm('Sicuro di voler eliminare questo oggetto?')">
            <i class="fas fa-trash-alt"></i>
            <span>Elimina</span>
        </a>
    </div>
    <?php } ?>

    <!-- Page Header con Breadcrumb -->
    <div class="page-header">
        <div class="page-breadcrumb">
            <a href="<?php print $shop_url; ?>"><i class="fas fa-home"></i> Home</a>
            <i class="fas fa-chevron-right"></i>
            <a href="<?php print $shop_url.'category/'.$item[0]['category'].'/'; ?>"><?php print is_get_category_name($item[0]['category']); ?></a>
            <i class="fas fa-chevron-right"></i>
            <span><?php print $item_name; ?></span>
        </div>
    </div>

    <!-- Purchase Alert Messages -->
    <?php
    if(is_loggedin()) {
        if(isset($_POST['buy']) && isset($_POST['buy_key']) && $_POST['buy_key'] == $_SESSION['buy_key']) {
            if($total <= is_coins($item[0]['pay_type'] - 1)) {
                if (is_buy_item($get_item, [])) {
                    is_pay_coins($item[0]['pay_type'] - 1, $total);
                    echo '<div class="alert-message alert-success">
                            <i class="fas fa-check-circle"></i>
                            <div>
                                <strong>Acquisto completato!</strong>
                                <p>L\'oggetto è stato aggiunto al tuo inventario.</p>
                            </div>
                          </div>';
                } else {
                    echo '<div class="alert-message alert-danger">
                            <i class="fas fa-exclamation-triangle"></i>
                            <div>
                                <strong>Spazio insufficiente!</strong>
                                <p>Non hai abbastanza spazio nel magazzino item shop.</p>
                            </div>
                          </div>';
                }
            } else {
                echo '<div class="alert-message alert-danger">
                        <i class="fas fa-wallet"></i>
                        <div>
                            <strong>Fondi insufficienti!</strong>
                            <p>Non hai abbastanza MD Coins per completare l\'acquisto.</p>
                        </div>
                      </div>';
            }
        }
        $_SESSION['buy_key'] = mt_rand(1, 1000);
    }
    ?>

    <!-- Main Item Content Grid -->
    <div class="item-detail-grid">

        <!-- Left Column: Item Image & Info -->
        <div class="item-detail-left">

            <!-- Item Showcase Card -->
            <div class="detail-card item-showcase-card">
                <div class="item-showcase-image">
                    <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum'], $item[0]['id']); ?>.png"
                         alt="<?php print $item_name; ?>">
                </div>
                <h2 class="item-showcase-title"><?php print $item_name; ?></h2>

                <!-- Item Badges -->
                <div class="item-showcase-badges">
                    <?php if($item[0]['discount'] > 0) {
                        $discount_expire = date("Y-m-d H:i:s", $item[0]['discount_expire']);
                    ?>
                    <div class="showcase-badge badge-discount">
                        <i class="fas fa-percentage"></i>
                        <div class="badge-content">
                            <span class="badge-label">Sconto Attivo</span>
                            <span class="badge-value">-<?php print $item[0]['discount']; ?>%</span>
                            <?php if($item[0]['discount_expire'] > 0) { ?>
                            <span class="badge-timer countdown-timer" data-countdown="<?php print $discount_expire; ?>"></span>
                            <?php } ?>
                        </div>
                    </div>
                    <?php } ?>

                    <?php if($item[0]['expire'] > 0) {
                        $promo_expire = date("Y-m-d H:i:s", $item[0]['expire']);
                    ?>
                    <div class="showcase-badge badge-timer">
                        <i class="fas fa-fire"></i>
                        <div class="badge-content">
                            <span class="badge-label">Offerta a Tempo</span>
                            <span class="badge-timer countdown-timer" data-countdown="<?php print $promo_expire; ?>"></span>
                        </div>
                    </div>
                    <?php } ?>

                    <?php if($item[0]['type'] == 3) { ?>
                    <div class="showcase-badge badge-bonus">
                        <i class="fas fa-star"></i>
                        <div class="badge-content">
                            <span class="badge-label">Bonus Selezionabili</span>
                            <span class="badge-value"><?php print $count; ?> disponibili</span>
                        </div>
                    </div>
                    <?php } ?>

                    <?php if($item[0]['count'] > 1) { ?>
                    <div class="showcase-badge badge-quantity">
                        <i class="fas fa-layer-group"></i>
                        <div class="badge-content">
                            <span class="badge-label">Quantità</span>
                            <span class="badge-value"><?php print $item[0]['count']; ?>x</span>
                        </div>
                    </div>
                    <?php } ?>
                </div>
            </div>

            <!-- Item Description Card -->
            <?php if(!empty($item[0]['description'])) { ?>
            <div class="detail-card item-description-card">
                <div class="card-header">
                    <i class="fas fa-align-left"></i>
                    <h3>Descrizione</h3>
                </div>
                <div class="card-body">
                    <p class="item-description-text"><?php print nl2br(htmlspecialchars($item[0]['description'])); ?></p>
                </div>
            </div>
            <?php } ?>

        </div>

        <!-- Right Column: Stats & Purchase -->
        <div class="item-detail-right">

            <!-- Price & Purchase Card -->
            <div class="detail-card item-purchase-card">
                <div class="purchase-price-section">
                    <div class="price-label">Prezzo</div>
                    <div class="price-display">
                        <img src="<?php print $shop_url; ?>images/<?php print ($item[0]['pay_type']==1) ? 'monet' : 'jd'; ?>.png" alt="Coins">
                        <div class="price-values">
                            <?php if($item[0]['discount'] > 0) { ?>
                            <span class="price-original"><?php print number_format($price1, 0, '', ','); ?></span>
                            <?php } ?>
                            <span class="price-current"><?php print number_format($total, 0, '', ','); ?></span>
                            <span class="price-currency">MD COINS</span>
                        </div>
                    </div>
                </div>

                <?php if(is_loggedin()) { ?>
                <form action="" method="post" id="buy_item_form">
                    <input type="hidden" name="buy_key" value="<?php print $_SESSION['buy_key']; ?>">
                    <button type="submit" name="buy" class="btn-purchase-primary" <?php if(is_coins($item[0]['pay_type']-1) < $total) print 'disabled'; ?>>
                        <i class="fas fa-shopping-cart"></i>
                        <span><?php print (is_coins($item[0]['pay_type']-1) < $total) ? 'Fondi Insufficienti' : 'Acquista Ora'; ?></span>
                    </button>
                </form>

                <div class="purchase-wallet-info">
                    <div class="wallet-row">
                        <span class="wallet-label">Il tuo saldo:</span>
                        <span class="wallet-value"><?php print number_format(is_coins($item[0]['pay_type']-1), 0, '', ','); ?> MD</span>
                    </div>
                    <?php if(is_coins($item[0]['pay_type']-1) >= $total) { ?>
                    <div class="wallet-row">
                        <span class="wallet-label">Dopo l'acquisto:</span>
                        <span class="wallet-value"><?php print number_format(is_coins($item[0]['pay_type']-1) - $total, 0, '', ','); ?> MD</span>
                    </div>
                    <?php } ?>
                </div>
                <?php } else { ?>
                <a href="<?php print $shop_url; ?>login" class="btn-purchase-primary">
                    <i class="fas fa-lock"></i>
                    <span>Effettua il Login</span>
                </a>
                <div class="login-notice">
                    <i class="fas fa-info-circle"></i>
                    <p>Effettua il login per acquistare questo oggetto</p>
                </div>
                <?php } ?>
            </div>

            <!-- Item Stats Card -->
            <div class="detail-card item-stats-card">
                <div class="card-header">
                    <i class="fas fa-chart-bar"></i>
                    <h3>Statistiche Oggetto</h3>
                </div>
                <div class="card-body">
                    <ul class="item-stats-list">
                        <?php
                        // Livello richiesto
                        $lvl = get_item_lvl($item[0]['vnum']);
                        if($lvl) {
                            echo '<li class="stat-item">
                                    <span class="stat-label"><i class="fas fa-star"></i> Livello Richiesto</span>
                                    <span class="stat-value">Lv. '.$lvl.'</span>
                                  </li>';
                        }

                        // Quantità
                        if($item[0]['count'] > 1) {
                            echo '<li class="stat-item">
                                    <span class="stat-label"><i class="fas fa-layer-group"></i> Quantità</span>
                                    <span class="stat-value">'.$item[0]['count'].' unità</span>
                                  </li>';
                        }

                        // Durata oggetto
                        if($item[0]['item_unique'] == 1 || $item[0]['item_unique'] == 2) {
                            echo '<li class="stat-item">
                                    <span class="stat-label"><i class="fas fa-hourglass-half"></i> Durata</span>
                                    <span class="stat-value">';
                            is_get_item_time($get_item);
                            echo '</span></li>';
                        }

                        // Assorbimento (per fasce)
                        if(check_item_sash($item[0]['vnum'])) {
                            echo '<li class="stat-item">
                                    <span class="stat-label"><i class="fas fa-shield-alt"></i> Assorbimento</span>
                                    <span class="stat-value">'.is_get_sash_absorption($get_item).'%</span>
                                  </li>';
                        }

                        // Bonus item (function che stampa HTML)
                        is_get_item($get_item);

                        // Bonus fascia
                        if(check_item_sash($item[0]['vnum'])) {
                            is_get_sash_bonuses($get_item);
                        }

                        // Pietre incastonate
                        if(get_item_name($item[0]['socket0'])) {
                            get_item_stones_market($get_item);
                        }

                        // VNUM per admin
                        if(is_loggedin() && web_admin_level()>=9) {
                            echo '<li class="stat-item stat-admin">
                                    <span class="stat-label"><i class="fas fa-code"></i> VNUM</span>
                                    <span class="stat-value">'.$item[0]['vnum'].'</span>
                                  </li>';
                        }
                        ?>
                    </ul>
                </div>
            </div>

        </div>

    </div>

</div>

<!-- Modal Conferma Acquisto -->
<div id="purchaseConfirmModal" class="modal-overlay" style="display: none;">
    <div class="modal-container">
        <div class="modal-header">
            <i class="fas fa-shopping-cart"></i>
            <h3>Conferma Acquisto</h3>
        </div>
        <div class="modal-body">
            <div class="modal-item-preview">
                <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum'], $item[0]['id']); ?>.png" alt="Item">
                <div class="modal-item-info">
                    <h4><?php print $item_name; ?></h4>
                    <p>Quantità: <strong><?php print $item[0]['count']; ?>x</strong></p>
                </div>
            </div>

            <div class="modal-price-summary">
                <div class="summary-row">
                    <span>Prezzo unitario:</span>
                    <span class="price-value">
                        <img src="<?php print $shop_url; ?>images/<?php print ($item[0]['pay_type']==1) ? 'monet' : 'jd'; ?>.png" alt="MD">
                        <?php print number_format($item[0]['coins'], 0, '', ','); ?> MD
                    </span>
                </div>
                <?php if($item[0]['discount'] > 0): ?>
                <div class="summary-row discount">
                    <span>Sconto:</span>
                    <span class="discount-value">-<?php print $item[0]['discount']; ?>%</span>
                </div>
                <?php endif; ?>
                <div class="summary-row total">
                    <span>Totale:</span>
                    <span class="total-value">
                        <img src="<?php print $shop_url; ?>images/<?php print ($item[0]['pay_type']==1) ? 'monet' : 'jd'; ?>.png" alt="MD">
                        <?php print number_format($total, 0, '', ','); ?> MD
                    </span>
                </div>
            </div>

            <div class="modal-wallet-info">
                <p>Il tuo saldo attuale: <strong><?php print number_format(is_coins($item[0]['pay_type']-1), 0, '', ','); ?> MD</strong></p>
                <p>Saldo dopo l'acquisto: <strong class="remaining-balance"><?php print number_format(is_coins($item[0]['pay_type']-1) - $total, 0, '', ','); ?> MD</strong></p>
            </div>

            <p class="modal-question">Sei sicuro di voler procedere con l'acquisto?</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn-modal btn-cancel" onclick="closeConfirmModal()">
                <i class="fas fa-times"></i>
                <span>Annulla</span>
            </button>
            <button type="button" class="btn-modal btn-confirm" onclick="confirmPurchase()">
                <i class="fas fa-check"></i>
                <span>Conferma Acquisto</span>
            </button>
        </div>
    </div>
</div>

<script>
// Modal Management
document.addEventListener('DOMContentLoaded', function() {
    const buyForm = document.getElementById('buy_item_form');
    const modal = document.getElementById('purchaseConfirmModal');

    if (buyForm) {
        buyForm.addEventListener('submit', function(e) {
            e.preventDefault();
            modal.style.display = 'flex';
        });
    }
});

function closeConfirmModal() {
    const modal = document.getElementById('purchaseConfirmModal');
    modal.style.animation = 'fadeOut 0.3s ease-out';
    setTimeout(() => {
        modal.style.display = 'none';
        modal.style.animation = '';
    }, 300);
}

function confirmPurchase() {
    const buyForm = document.getElementById('buy_item_form');
    const confirmBtn = document.querySelector('.btn-confirm');

    confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Acquisto in corso...</span>';
    confirmBtn.disabled = true;

    // Add hidden buy field
    const hiddenBuy = document.createElement('input');
    hiddenBuy.type = 'hidden';
    hiddenBuy.name = 'buy';
    hiddenBuy.value = '1';
    buyForm.appendChild(hiddenBuy);

    setTimeout(() => {
        buyForm.submit();
    }, 500);
}

// Close modal on outside click
document.addEventListener('click', function(e) {
    const modal = document.getElementById('purchaseConfirmModal');
    if (e.target === modal) {
        closeConfirmModal();
    }
});

// Close modal with ESC key
document.addEventListener('keydown', function(e) {
    const modal = document.getElementById('purchaseConfirmModal');
    if (e.key === 'Escape' && modal.style.display === 'flex') {
        closeConfirmModal();
    }
});
</script>
