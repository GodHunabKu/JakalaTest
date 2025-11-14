<?php
// Verifica accesso admin
if(!is_loggedin() || web_admin_level() < 9) {
    redirect($shop_url);
    exit;
}

$migration_done = false;
$migration_error = false;
$error_message = '';
$success_messages = [];

// Controlla lo stato attuale delle colonne
$has_custom_image = check_item_column("custom_image");
$has_sort_order = check_item_column("sort_order");

// Esegui migrazione se richiesto
if(isset($_POST['migrate']) && (!$has_custom_image || !$has_sort_order)) {
    try {
        $db = $database->getPDO();
        $db->beginTransaction();

        // 1. Aggiungi custom_image se non esiste
        if(!$has_custom_image) {
            $db->exec("ALTER TABLE item_shop_items ADD COLUMN custom_image TEXT DEFAULT NULL");
            $success_messages[] = "✓ Aggiunta colonna 'custom_image'";
        }

        // 2. Aggiungi sort_order se non esiste
        if(!$has_sort_order) {
            $db->exec("ALTER TABLE item_shop_items ADD COLUMN sort_order INTEGER DEFAULT 0");
            $success_messages[] = "✓ Aggiunta colonna 'sort_order'";

            // 3. Inizializza sort_order con ID per item esistenti
            $db->exec("UPDATE item_shop_items SET sort_order = id WHERE sort_order = 0 OR sort_order IS NULL");
            $success_messages[] = "✓ Inizializzato sort_order per item esistenti";
        }

        $db->commit();
        $migration_done = true;

        // Ricarica lo stato
        $has_custom_image = true;
        $has_sort_order = true;

    } catch(Exception $e) {
        if($db && $db->inTransaction()) {
            $db->rollBack();
        }
        $migration_error = true;
        $error_message = $e->getMessage();
    }
}
?>

<div class="admin-content-wrapper">
    <!-- Page Header -->
    <div class="admin-page-header">
        <div class="header-left">
            <a href="<?php print $shop_url.'settings'; ?>" class="btn-back">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Settings</span>
            </a>
        </div>
        <div class="header-center">
            <i class="fas fa-database"></i>
            <h1>Database Migration</h1>
            <p>Add new features to your shop database</p>
        </div>
    </div>

    <!-- Migration Status -->
    <div class="migration-status-card">
        <div class="status-header">
            <i class="fas fa-info-circle"></i>
            <h3>Database Status</h3>
        </div>
        <div class="status-body">
            <div class="status-item <?php echo $has_custom_image ? 'status-ok' : 'status-pending'; ?>">
                <i class="fas <?php echo $has_custom_image ? 'fa-check-circle' : 'fa-exclamation-triangle'; ?>"></i>
                <div class="status-info">
                    <strong>Custom Image Names</strong>
                    <span><?php echo $has_custom_image ? 'Installato - Puoi usare nomi custom per le immagini' : 'Non installato - Solo immagini VNUM disponibili'; ?></span>
                </div>
            </div>
            <div class="status-item <?php echo $has_sort_order ? 'status-ok' : 'status-pending'; ?>">
                <i class="fas <?php echo $has_sort_order ? 'fa-check-circle' : 'fa-exclamation-triangle'; ?>"></i>
                <div class="status-info">
                    <strong>Custom Sort Order</strong>
                    <span><?php echo $has_sort_order ? 'Installato - Puoi riordinare gli item manualmente' : 'Non installato - Solo ordinamento per ID'; ?></span>
                </div>
            </div>
        </div>
    </div>

    <!-- Success Messages -->
    <?php if($migration_done && !empty($success_messages)) { ?>
    <div class="alert alert-success">
        <i class="fas fa-check-circle"></i>
        <div>
            <strong>Migrazione completata con successo!</strong>
            <ul style="margin: 10px 0 0 0; padding-left: 20px;">
                <?php foreach($success_messages as $msg) { ?>
                <li><?php echo $msg; ?></li>
                <?php } ?>
            </ul>
        </div>
    </div>
    <?php } ?>

    <!-- Error Message -->
    <?php if($migration_error) { ?>
    <div class="alert alert-danger">
        <i class="fas fa-exclamation-circle"></i>
        <div>
            <strong>Errore durante la migrazione!</strong>
            <p style="margin: 5px 0 0 0;"><?php echo htmlspecialchars($error_message); ?></p>
        </div>
    </div>
    <?php } ?>

    <!-- Migration Form -->
    <?php if(!$has_custom_image || !$has_sort_order) { ?>
    <div class="migration-card">
        <div class="card-header">
            <i class="fas fa-rocket"></i>
            <h3>Installa Nuove Funzionalità</h3>
        </div>
        <div class="card-body">
            <p class="migration-description">
                Questa migrazione aggiungerà le seguenti funzionalità al tuo shop:
            </p>
            <ul class="feature-list">
                <?php if(!$has_custom_image) { ?>
                <li>
                    <i class="fas fa-image"></i>
                    <strong>Nomi immagini custom:</strong> Usa nomi come "incantamedi.png" invece di solo numeri VNUM
                </li>
                <?php } ?>
                <?php if(!$has_sort_order) { ?>
                <li>
                    <i class="fas fa-sort"></i>
                    <strong>Ordinamento personalizzato:</strong> Riordina gli item come preferisci, non solo per ID
                </li>
                <?php } ?>
            </ul>

            <div class="migration-warning">
                <i class="fas fa-shield-alt"></i>
                <p><strong>Sicuro e Reversibile:</strong> La migrazione aggiunge solo nuove colonne, non modifica dati esistenti. Il tuo shop continuerà a funzionare normalmente.</p>
            </div>

            <form method="post" style="margin-top: 20px;">
                <button type="submit" name="migrate" class="btn-migrate" onclick="return confirm('Sei sicuro di voler eseguire la migrazione del database?')">
                    <i class="fas fa-play-circle"></i>
                    <span>Esegui Migrazione</span>
                </button>
            </form>
        </div>
    </div>
    <?php } else { ?>
    <div class="migration-complete">
        <i class="fas fa-check-circle"></i>
        <h3>Tutte le funzionalità sono installate!</h3>
        <p>Il tuo database è aggiornato con tutte le nuove funzionalità.</p>
        <a href="<?php print $shop_url.'settings'; ?>" class="btn-return">
            <i class="fas fa-arrow-left"></i>
            <span>Torna alle Impostazioni</span>
        </a>
    </div>
    <?php } ?>
</div>

<style>
.migration-status-card,
.migration-card {
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 16px;
    padding: 25px;
    margin-bottom: 25px;
}

.status-header,
.card-header {
    display: flex;
    align-items: center;
    gap: 12px;
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid var(--glass-border);
}

.status-header i,
.card-header i {
    font-size: 24px;
    color: var(--one-scarlet);
}

.status-header h3,
.card-header h3 {
    margin: 0;
    font-size: 20px;
    color: #333;
}

.status-item {
    display: flex;
    align-items: flex-start;
    gap: 15px;
    padding: 15px;
    margin-bottom: 10px;
    border-radius: 8px;
    background: rgba(255, 255, 255, 0.5);
}

.status-item.status-ok {
    background: rgba(40, 167, 69, 0.1);
    border-left: 4px solid #28a745;
}

.status-item.status-pending {
    background: rgba(255, 193, 7, 0.1);
    border-left: 4px solid #ffc107;
}

.status-item i {
    font-size: 24px;
    margin-top: 2px;
}

.status-item.status-ok i {
    color: #28a745;
}

.status-item.status-pending i {
    color: #ffc107;
}

.status-info {
    flex: 1;
}

.status-info strong {
    display: block;
    font-size: 16px;
    color: #333;
    margin-bottom: 5px;
}

.status-info span {
    display: block;
    font-size: 14px;
    color: #666;
}

.migration-description {
    font-size: 15px;
    color: #555;
    margin-bottom: 15px;
}

.feature-list {
    list-style: none;
    padding: 0;
    margin: 20px 0;
}

.feature-list li {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 12px;
    margin-bottom: 10px;
    background: rgba(220, 20, 60, 0.05);
    border-radius: 8px;
    border-left: 3px solid var(--one-scarlet);
}

.feature-list li i {
    color: var(--one-scarlet);
    font-size: 18px;
    margin-top: 2px;
}

.migration-warning {
    display: flex;
    align-items: flex-start;
    gap: 12px;
    padding: 15px;
    background: rgba(23, 162, 184, 0.1);
    border-radius: 8px;
    border-left: 3px solid #17a2b8;
    margin-top: 20px;
}

.migration-warning i {
    color: #17a2b8;
    font-size: 20px;
    margin-top: 2px;
}

.migration-warning p {
    margin: 0;
    color: #555;
    font-size: 14px;
}

.btn-migrate {
    width: 100%;
    padding: 15px 30px;
    background: linear-gradient(135deg, var(--one-scarlet) 0%, rgba(139, 0, 0, 0.9) 100%);
    border: none;
    border-radius: 10px;
    color: white;
    font-size: 16px;
    font-weight: 700;
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 10px;
    cursor: pointer;
    transition: all 0.3s ease;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.btn-migrate:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 30px rgba(220, 20, 60, 0.4);
}

.btn-migrate i {
    font-size: 20px;
}

.migration-complete {
    text-align: center;
    padding: 60px 20px;
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 16px;
}

.migration-complete i {
    font-size: 80px;
    color: #28a745;
    margin-bottom: 20px;
}

.migration-complete h3 {
    font-size: 28px;
    color: #333;
    margin-bottom: 10px;
}

.migration-complete p {
    font-size: 16px;
    color: #666;
    margin-bottom: 30px;
}

.btn-return {
    display: inline-flex;
    align-items: center;
    gap: 10px;
    padding: 12px 30px;
    background: var(--one-scarlet);
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 600;
    transition: all 0.3s ease;
}

.btn-return:hover {
    background: rgba(139, 0, 0, 0.9);
    transform: translateY(-2px);
}

.alert {
    padding: 20px;
    border-radius: 12px;
    margin-bottom: 25px;
    display: flex;
    align-items: flex-start;
    gap: 15px;
}

.alert-success {
    background: rgba(40, 167, 69, 0.1);
    border-left: 4px solid #28a745;
    color: #155724;
}

.alert-danger {
    background: rgba(220, 53, 69, 0.1);
    border-left: 4px solid #dc3545;
    color: #721c24;
}

.alert i {
    font-size: 24px;
    margin-top: 2px;
}

.alert-success i {
    color: #28a745;
}

.alert-danger i {
    color: #dc3545;
}

.alert strong {
    display: block;
    margin-bottom: 5px;
    font-size: 16px;
}
</style>
