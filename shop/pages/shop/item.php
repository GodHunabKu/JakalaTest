<?php
// ----------- INIZIO DEL FILE pages/shop/item.php -----------

// Il router (index.php) ha già definito $get_item (l'ID dell'oggetto nello shop)
// Se non è definito o non è numerico, esce per sicurezza.
if (!isset($get_item) || !is_numeric($get_item)) {
    redirect($shop_url);
}

// Recuperiamo i dati dell'oggetto dal database dello SHOP (SQLite)
$item = is_item_select($get_item);

// Se l'oggetto non esiste nel DB dello shop, reindirizza alla home.
if (!count($item)) {
    redirect($shop_url);
}

// Calcolo del prezzo (con eventuale sconto)
$price1 = $item[0]['coins'];
if ($item[0]['discount'] > 0) {
    $total = $item[0]['coins'] - ($item[0]['coins'] * $item[0]['discount'] / 100);
} else {
    $total = $item[0]['coins'];
}

// Se l'oggetto è di tipo 'bonus selezionabili', recuperiamo i bonus disponibili
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

// ============== NUOVA LOGICA CENTRALE ==============
// Recuperiamo tutti i dettagli freschi da item_proto usando il VNUM
$proto_details = get_item_details_from_proto($item[0]['vnum']);
// =======================================================

// A questo punto, il resto del file HTML/PHP userà i dati dalle variabili $item e $proto_details
?>

<!-- Struttura basata sullo screenshot fornito -->
<div class="shop-content-wrapper">

    <!-- Notifiche di acquisto (se presenti) -->
    <?php
    if(is_loggedin()) {
        if(isset($_POST['buy']) && isset($_POST['buy_key']) && $_POST['buy_key'] == $_SESSION['buy_key']) {
            // ... (Qui ci andrebbe la logica di acquisto completa, come nel tuo file originale)
            // Per esempio:
            $ok = 0;
            if($total <= is_coins($item[0]['pay_type'] - 1)) {
                if (is_buy_item($get_item, [])) { // Passiamo un array vuoto per i bonus se non applicabile
                    is_pay_coins($item[0]['pay_type'] - 1, $total);
                    echo '<div class="alert alert-success">Acquisto effettuato con successo!</div>';
                } else {
                    echo '<div class="alert alert-danger">Spazio insufficiente nel magazzino item shop!</div>';
                }
            } else {
                 echo '<div class="alert alert-danger">Fondi insufficienti!</div>';
            }
        }
        $_SESSION['buy_key'] = mt_rand(1, 1000);
    }
    ?>

    <!-- Sezione principale dell'oggetto -->
    <div class="item-view-container"> <!-- Assumo una classe contenitore principale -->

        <!-- Pannello Admin -->
        <?php if(is_loggedin() && web_admin_level()>=9): ?>
        <div class="admin-actions-bar">
            <a href="<?php print $shop_url.'remove/item/'.$get_item.'/'.$item[0]['category'].'/'; ?>" class="btn-admin btn-admin-danger" onclick="return confirm('Sicuro di voler rimuovere questo oggetto?')">
                <i class="fas fa-trash"></i>
                <span>Rimuovere oggetto</span>
            </a>
            <button class="btn-admin btn-admin-primary" onclick="/* Funzione JS per mostrare il pannello sconti */">
                <i class="fas fa-percentage"></i>
                <span>Sconto (- XX%)</span>
            </button>
        </div>
        <?php endif; ?>

        <!-- Contenuto centrale con immagine e dettagli -->
        <div class="item-main-details">
            <div class="item-image-box">
                <!-- Immagine e nome come nello screenshot -->
                <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum']); ?>.png" alt="<?php echo $proto_details ? $proto_details['name'] : 'Oggetto'; ?>">
                <h3><?php echo $proto_details ? $proto_details['name'] : 'Oggetto non Trovato'; ?></h3>
            </div>
            
            <!-- Offerta a tempo -->
            <?php if($item[0]['expire'] > 0): $promo_expire = date("Y-m-d H:i:s", $item[0]['expire']); ?>
            <div class="promo-timer-box">
                <h4>OFFERTA A TEMPO</h4>
                <div class="countdown-timer" data-countdown="<?php print $promo_expire; ?>"></div>
            </div>
            <?php endif; ?>

            <!-- ======================================================= -->
            <!--   BOX STATISTICHE OGGETTO - MODIFICATO E COMPLETATO   -->
            <!-- ======================================================= -->
            <div class="item-stats-box">
                <h4>STATISTICHE OGGETTO</h4>
                <div class="item-stats-content">
                    <ul style="list-style: none; padding: 15px; margin: 0; font-size: 14px; color: #ccc;">
                        
                        <?php if ($proto_details): ?>
                            <!-- Livello Richiesto -->
                            <?php if ($proto_details['level'] > 0): ?>
                                <li style="margin-bottom: 10px; overflow: hidden;">
                                    Livello Richiesto
                                    <b style="color: white; float: right;"><?php echo $proto_details['level']; ?></b>
                                </li>
                            <?php endif; ?>
                            <!-- Valore Attacco -->
                            <?php if ($proto_details['attack_value']): ?>
                                <li style="margin-bottom: 10px; overflow: hidden;">
                                    Valore Attacco
                                    <b style="color: white; float: right;"><?php echo $proto_details['attack_value']; ?></b>
                                </li>
                            <?php endif; ?>
                            <!-- Attacco Magico -->
                            <?php if ($proto_details['magic_attack']): ?>
                                <li style="margin-bottom: 10px; overflow: hidden;">
                                    Attacco Magico
                                    <b style="color: white; float: right;"><?php echo $proto_details['magic_attack']; ?></b>
                                </li>
                            <?php endif; ?>
                            <!-- Divider -->
                            <?php if (!empty($proto_details['bonuses'])): ?>
                                <hr style="border: 0; border-top: 1px solid #444; margin: 10px 0;">
                            <?php endif; ?>
                            <!-- Lista Bonus da item_proto -->
                            <?php foreach ($proto_details['bonuses'] as $bonus): ?>
                                <li style="margin-bottom: 10px; color: #28a745;"><?php echo $bonus; ?></li>
                            <?php endforeach; ?>
                        <?php else: ?>
                            <li><p>Impossibile caricare le statistiche dal database del gioco.</p></li>
                        <?php endif; ?>

                        <!-- Bonus extra dallo shop (se presenti) -->
                        <?php is_get_item($get_item); ?>

                        <!-- Mostra il VNUM per l'admin -->
                        <?php if(is_loggedin() && web_admin_level()>=9): ?>
                            <hr style="border: 0; border-top: 1px solid #444; margin: 10px 0;">
                            <li style="margin-bottom: 10px; overflow: hidden;">
                                VNUM
                                <b style="color: white; float: right;"><?php echo $item[0]['vnum']; ?></b>
                            </li>
                        <?php endif; ?>
                    </ul>
                </div>
            </div>
        </div>

        <!-- Colonna destra con Prezzo e Acquisto -->
        <div class="item-purchase-panel">
            <div class="price-box">
                <h4>PREZZO</h4>
                <div class="price-content">
                    <img src="<?php print $shop_url; ?>images/md.png" alt="MD Coins">
                    <span class="price-amount"><?php echo number_format($total); ?></span>
                    <span class="price-currency">MD COINS</span>
                </div>
            </div>
            <div class="description-box">
                <h4>DESCRIZIONE</h4>
                <p><?php echo !empty($item[0]['description']) ? nl2br(htmlspecialchars($item[0]['description'])) : 'Nessuna descrizione disponibile.'; ?></p>
            </div>
            
            <?php if(is_loggedin()): ?>
                <form action="" method="post" id="buy_item_form">
                    <input type="hidden" name="buy_key" value="<?php echo $_SESSION['buy_key']; ?>">
                    <button type="submit" name="buy" class="btn-purchase-main" <?php if(is_coins($item[0]['pay_type']-1) < $total) echo 'disabled'; ?>>
                        <i class="fas fa-shopping-cart"></i>
                        <span><?php echo (is_coins($item[0]['pay_type']-1) < $total) ? 'FONDI INSUFFICIENTI' : 'ACQUISTA ORA'; ?></span>
                    </button>
                </form>
            <?php else: ?>
                <a href="<?php echo $shop_url; ?>login" class="btn-purchase-main">
                    <i class="fas fa-lock"></i>
                    <span>EFFETTUA IL LOGIN</span>
                </a>
            <?php endif; ?>
        </div>

    </div>
</div>