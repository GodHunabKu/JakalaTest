<?php
// ----------- INIZIO DEL FILE pages/shop/item.php -----------

// Il router (index.php) ha gi� definito $get_item (l'ID dell'oggetto nello shop)
// Se non � definito o non � numerico, esce per sicurezza.
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

// Se l'oggetto � di tipo 'bonus selezionabili', recuperiamo i bonus disponibili
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

// A questo punto, il resto del file HTML/PHP user� i dati dalle variabili $item e $proto_details
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
            <a href="<?php print $shop_url.'edit/item/'.$get_item.'/'; ?>" class="btn-admin btn-admin-success">
                <i class="fas fa-edit"></i>
                <span>Edit Item</span>
            </a>
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
                <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item[0]['vnum'], $item[0]['id']); ?>.png" alt="<?php echo $proto_details ? $proto_details['name'] : 'Oggetto'; ?>">
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
                    <img src="<?php print $shop_url; ?>images/monet.png" alt="MD Coins">
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
                        <h4><?php if(!$item_name_db) print get_item_name($item[0]['vnum']); else print get_item_name_locale_name($item[0]['vnum']); ?></h4>
                        <p>Quantità: <strong><?php print $item[0]['count']; ?>x</strong></p>
                    </div>
                </div>

                <div class="modal-price-summary">
                    <div class="summary-row">
                        <span>Prezzo unitario:</span>
                        <span class="price-value">
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD" style="width: 20px; height: 20px;">
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
                            <img src="<?php print $shop_url; ?>images/monet.png" alt="MD" style="width: 24px; height: 24px;">
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

    <style>
    /* Modal Styles */
    .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.85);
        backdrop-filter: blur(10px);
        z-index: 10000;
        display: flex;
        align-items: center;
        justify-content: center;
        padding: 20px;
        animation: fadeIn 0.3s ease-out;
    }

    @keyframes fadeIn {
        from { opacity: 0; }
        to { opacity: 1; }
    }

    @keyframes slideUp {
        from {
            opacity: 0;
            transform: translateY(30px) scale(0.95);
        }
        to {
            opacity: 1;
            transform: translateY(0) scale(1);
        }
    }

    .modal-container {
        background: var(--glass-bg);
        border: 1px solid var(--glass-border);
        border-radius: 20px;
        max-width: 500px;
        width: 100%;
        box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
        animation: slideUp 0.3s ease-out;
    }

    .modal-header {
        background: linear-gradient(135deg, rgba(220, 20, 60, 0.2) 0%, rgba(139, 0, 0, 0.2) 100%);
        padding: 25px;
        text-align: center;
        border-bottom: 1px solid var(--glass-border);
        border-radius: 20px 20px 0 0;
    }

    .modal-header i {
        font-size: 48px;
        color: var(--one-scarlet);
        margin-bottom: 15px;
        display: block;
        animation: float 2s ease-in-out infinite;
    }

    @keyframes float {
        0%, 100% { transform: translateY(0); }
        50% { transform: translateY(-10px); }
    }

    .modal-header h3 {
        font-family: var(--font-heading);
        font-size: 24px;
        font-weight: 900;
        color: var(--text-primary);
        margin: 0;
        text-transform: uppercase;
        letter-spacing: 2px;
    }

    .modal-body {
        padding: 30px;
    }

    .modal-item-preview {
        display: flex;
        align-items: center;
        gap: 20px;
        background: rgba(255, 255, 255, 0.03);
        padding: 20px;
        border-radius: 12px;
        border: 1px solid var(--glass-border);
        margin-bottom: 25px;
    }

    .modal-item-preview img {
        width: 80px;
        height: 80px;
        object-fit: contain;
    }

    .modal-item-info h4 {
        font-family: var(--font-heading);
        font-size: 18px;
        font-weight: 700;
        color: var(--text-primary);
        margin: 0 0 8px 0;
    }

    .modal-item-info p {
        margin: 0;
        color: var(--text-secondary);
    }

    .modal-price-summary {
        background: rgba(255, 255, 255, 0.03);
        padding: 20px;
        border-radius: 12px;
        border: 1px solid var(--glass-border);
        margin-bottom: 20px;
    }

    .summary-row {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 12px;
        padding-bottom: 12px;
        border-bottom: 1px solid rgba(255, 255, 255, 0.05);
    }

    .summary-row:last-child {
        margin-bottom: 0;
        padding-bottom: 0;
        border-bottom: none;
    }

    .summary-row.total {
        margin-top: 15px;
        padding-top: 15px;
        border-top: 2px solid var(--one-scarlet);
    }

    .price-value, .total-value {
        display: flex;
        align-items: center;
        gap: 8px;
        font-weight: 600;
        color: var(--one-gold);
    }

    .discount-value {
        color: #4CAF50;
        font-weight: 700;
    }

    .total-value {
        font-family: var(--font-heading);
        font-size: 20px;
        font-weight: 900;
    }

    .modal-wallet-info {
        background: linear-gradient(135deg, rgba(255, 215, 0, 0.1) 0%, rgba(255, 215, 0, 0.05) 100%);
        border: 1px solid rgba(255, 215, 0, 0.3);
        padding: 15px;
        border-radius: 12px;
        margin-bottom: 20px;
    }

    .modal-wallet-info p {
        margin: 8px 0;
        color: var(--text-secondary);
    }

    .modal-wallet-info strong {
        color: var(--one-gold);
        font-family: var(--font-heading);
    }

    .remaining-balance {
        font-size: 18px;
    }

    .modal-question {
        text-align: center;
        font-size: 16px;
        font-weight: 600;
        color: var(--text-primary);
        margin: 20px 0 0 0;
    }

    .modal-footer {
        padding: 20px 30px 30px;
        display: flex;
        gap: 15px;
    }

    .btn-modal {
        flex: 1;
        padding: 15px 25px;
        border: none;
        border-radius: 12px;
        font-family: var(--font-heading);
        font-size: 14px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 1px;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        gap: 10px;
        transition: all 0.3s ease;
    }

    .btn-cancel {
        background: rgba(255, 255, 255, 0.05);
        border: 1px solid var(--glass-border);
        color: var(--text-primary);
    }

    .btn-cancel:hover {
        background: rgba(255, 255, 255, 0.1);
        transform: translateY(-2px);
    }

    .btn-confirm {
        background: linear-gradient(135deg, var(--one-scarlet) 0%, rgba(139, 0, 0, 0.9) 100%);
        color: white;
        box-shadow: 0 4px 15px rgba(220, 20, 60, 0.4);
    }

    .btn-confirm:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(220, 20, 60, 0.6);
    }

    @media (max-width: 600px) {
        .modal-container {
            margin: 20px;
        }

        .modal-footer {
            flex-direction: column;
        }

        .btn-modal {
            width: 100%;
        }
    }
    </style>

    <script>
    // Gestione conferma acquisto
    document.addEventListener('DOMContentLoaded', function() {
        const buyForm = document.getElementById('buy_item_form');
        const modal = document.getElementById('purchaseConfirmModal');

        if (buyForm) {
            buyForm.addEventListener('submit', function(e) {
                e.preventDefault();

                // Mostra modal
                modal.style.display = 'flex';

                // Aggiungi particelle
                createCelebrationParticles();
            });
        }
    });

    function closeConfirmModal() {
        const modal = document.getElementById('purchaseConfirmModal');
        modal.style.animation = 'fadeIn 0.3s ease-out reverse';
        setTimeout(() => {
            modal.style.display = 'none';
            modal.style.animation = '';
        }, 300);
    }

    function confirmPurchase() {
        const buyForm = document.getElementById('buy_item_form');

        // Crea effetto confetti
        createConfetti();

        // Disabilita i bottoni del modal
        const confirmBtn = document.querySelector('.btn-confirm');
        confirmBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i><span>Acquisto in corso...</span>';
        confirmBtn.disabled = true;

        // Submit del form reale dopo 500ms
        setTimeout(() => {
            buyForm.submit();
        }, 500);
    }

    function createCelebrationParticles() {
        const modal = document.querySelector('.modal-container');
        const particles = ['💎', '✨', '⭐', '🎁'];

        for (let i = 0; i < 10; i++) {
            const particle = document.createElement('span');
            particle.textContent = particles[Math.floor(Math.random() * particles.length)];
            particle.style.position = 'fixed';
            particle.style.left = Math.random() * 100 + '%';
            particle.style.top = '0';
            particle.style.fontSize = '24px';
            particle.style.pointerEvents = 'none';
            particle.style.zIndex = '10001';
            particle.style.animation = 'particleFall 3s ease-out forwards';
            particle.style.animationDelay = (i * 0.1) + 's';

            document.body.appendChild(particle);
            setTimeout(() => particle.remove(), 3000);
        }
    }

    function createConfetti() {
        const confettiCount = 50;
        const confettiChars = ['💎', '✨', '⭐', '💰', '🎁', '🌟', '🎉'];

        for (let i = 0; i < confettiCount; i++) {
            const confetti = document.createElement('div');
            confetti.textContent = confettiChars[Math.floor(Math.random() * confettiChars.length)];
            confetti.style.position = 'fixed';
            confetti.style.left = Math.random() * 100 + '%';
            confetti.style.top = '-50px';
            confetti.style.fontSize = (Math.random() * 20 + 15) + 'px';
            confetti.style.pointerEvents = 'none';
            confetti.style.zIndex = '10002';
            confetti.style.animation = `confettiFall ${Math.random() * 2 + 2}s ease-out forwards`;
            confetti.style.animationDelay = (i * 0.05) + 's';

            document.body.appendChild(confetti);
            setTimeout(() => confetti.remove(), 5000);
        }
    }

    // Animazioni CSS dinamiche
    const style = document.createElement('style');
    style.textContent = `
        @keyframes particleFall {
            to {
                transform: translateY(100vh) rotate(360deg);
                opacity: 0;
            }
        }

        @keyframes confettiFall {
            to {
                transform: translateY(100vh) rotate(720deg);
                opacity: 0;
            }
        }
    `;
    document.head.appendChild(style);

    // Chiudi modal cliccando fuori
    document.addEventListener('click', function(e) {
        const modal = document.getElementById('purchaseConfirmModal');
        if (e.target === modal) {
            closeConfirmModal();
        }
    });

    // Chiudi modal con ESC
    document.addEventListener('keydown', function(e) {
        const modal = document.getElementById('purchaseConfirmModal');
        if (e.key === 'Escape' && modal.style.display === 'flex') {
            closeConfirmModal();
        }
    });
    </script>
</div>