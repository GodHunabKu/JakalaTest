<?php
// Verifica che sia fornito un ID item
if (!isset($get_edit) || !is_numeric($get_edit)) {
    redirect($shop_url);
}

// Carica i dati dell'item
$stmt = $database->runQuerySqlite('SELECT * FROM item_shop_items WHERE id = ?');
$stmt->execute([$get_edit]);
$item = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$item) {
    redirect($shop_url);
}

// Gestione dell'update
$updated = false;
$error = false;

if (isset($_POST['update'])) {
    // CSRF Protection
    csrf_check();

    try {
        // Prepara i dati
        $vnum = intval($_POST['vnum']);
        $description = $_POST['description'];
        $coins = intval($_POST['coins']);
        $count = intval($_POST['count']) > 0 ? intval($_POST['count']) : 1;
        $discount = isset($_POST['discount']) ? intval($_POST['discount']) : 0;
        $custom_image = !empty($_POST['custom_image']) ? trim($_POST['custom_image']) : null;
        $sort_order = isset($_POST['sort_order']) ? intval($_POST['sort_order']) : $item['id'];

        // Calcola expire per promotion
        $expire = 0;
        if (!empty($_POST['promotion_months']) || !empty($_POST['promotion_days']) ||
            !empty($_POST['promotion_hours']) || !empty($_POST['promotion_minutes'])) {
            $expire = strtotime("now +" . intval($_POST['promotion_months']) . " month +" .
                               intval($_POST['promotion_days']) . " day +" .
                               intval($_POST['promotion_hours']) . " hours +" .
                               intval($_POST['promotion_minutes']) . " minute - 1 hour UTC");
        }

        // Calcola discount_expire
        $discount_expire = 0;
        if ($discount > 0 && (!empty($_POST['discount_months']) || !empty($_POST['discount_days']) ||
            !empty($_POST['discount_hours']) || !empty($_POST['discount_minutes']))) {
            $discount_expire = strtotime("now +" . intval($_POST['discount_months']) . " month +" .
                                        intval($_POST['discount_days']) . " day +" .
                                        intval($_POST['discount_hours']) . " hours +" .
                                        intval($_POST['discount_minutes']) . " minute - 1 hour UTC");
        }

        // Update query - gestisce sia con che senza custom_image/sort_order
        $update_fields = [
            'vnum = ?',
            'description = ?',
            'coins = ?',
            'count = ?',
            'discount = ?',
            'expire = ?',
            'discount_expire = ?'
        ];

        $update_values = [$vnum, $description, $coins, $count, $discount, $expire, $discount_expire];

        // Controlla se le colonne custom_image e sort_order esistono
        $columns_check = $database->runQuerySqlite("PRAGMA table_info(item_shop_items)");
        $existing_columns = [];
        foreach ($columns_check as $col) {
            $existing_columns[] = $col['name'];
        }

        if (in_array('custom_image', $existing_columns)) {
            $update_fields[] = 'custom_image = ?';
            $update_values[] = $custom_image;
        }

        if (in_array('sort_order', $existing_columns)) {
            $update_fields[] = 'sort_order = ?';
            $update_values[] = $sort_order;
        }

        $update_values[] = $get_edit; // WHERE id = ?

        $sql = "UPDATE item_shop_items SET " . implode(', ', $update_fields) . " WHERE id = ?";
        $stmt = $database->runQuerySqlite($sql);
        $stmt->execute($update_values);

        $updated = true;

        // Ricarica i dati aggiornati
        $stmt = $database->runQuerySqlite('SELECT * FROM item_shop_items WHERE id = ?');
        $stmt->execute([$get_edit]);
        $item = $stmt->fetch(PDO::FETCH_ASSOC);

    } catch (Exception $e) {
        $error = true;
        $error_message = $e->getMessage();
    }
}

// Calcola i valori attuali per i campi tempo
$promotion_total_minutes = 0;
if ($item['expire'] > 0) {
    $now = time();
    $diff = $item['expire'] - $now;
    if ($diff > 0) {
        $promotion_total_minutes = floor($diff / 60);
    }
}

$discount_total_minutes = 0;
if ($item['discount_expire'] > 0) {
    $now = time();
    $diff = $item['discount_expire'] - $now;
    if ($diff > 0) {
        $discount_total_minutes = floor($diff / 60);
    }
}
?>

<div class="admin-content-wrapper">
    <!-- Page Header -->
    <div class="admin-page-header">
        <div class="header-left">
            <a href="<?php print $shop_url . 'category/' . $item['category'] . '/'; ?>" class="btn-back">
                <i class="fas fa-arrow-left"></i>
                <span>Back to Items</span>
            </a>
        </div>
        <div class="header-center">
            <i class="fas fa-edit"></i>
            <h1>Edit Item</h1>
            <p>Item ID: <strong>#<?php print $item['id']; ?></strong></p>
        </div>
    </div>

    <!-- Alert Messages -->
    <?php if ($updated) { ?>
    <div class="alert-message alert-success">
        <i class="fas fa-check-circle"></i>
        <span>Item updated successfully!</span>
    </div>
    <?php } ?>

    <?php if ($error) { ?>
    <div class="alert-message alert-error">
        <i class="fas fa-exclamation-circle"></i>
        <span>Error updating item: <?php echo htmlspecialchars($error_message); ?></span>
    </div>
    <?php } ?>

    <!-- Edit Form -->
    <form action="" method="post" class="admin-form">
        <?php echo csrf_field(); ?>
        <div class="form-card">
            <div class="form-card-header">
                <i class="fas fa-info-circle"></i>
                <h3>Basic Information</h3>
            </div>
            <div class="form-card-body">
                <!-- VNUM -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-hashtag"></i>
                        Item VNUM *
                    </label>
                    <input type="number" class="form-input" name="vnum" value="<?php echo $item['vnum']; ?>" required>
                    <small>Item proto ID (cannot change item type)</small>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-align-left"></i>
                        Description
                    </label>
                    <textarea class="form-input" name="description" rows="4" style="resize: vertical;"><?php echo htmlspecialchars($item['description']); ?></textarea>
                </div>

                <!-- Price & Count -->
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-coins"></i>
                            Price (MD Coins) *
                        </label>
                        <input type="number" class="form-input" name="coins" value="<?php echo $item['coins']; ?>" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">
                            <i class="fas fa-layer-group"></i>
                            Quantity *
                        </label>
                        <input type="number" class="form-input" name="count" value="<?php echo $item['count']; ?>" min="1" required>
                    </div>
                </div>

                <!-- Custom Image -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-image"></i>
                        Custom Image Name (Optional)
                    </label>
                    <input type="text" class="form-input" name="custom_image"
                           value="<?php echo isset($item['custom_image']) ? htmlspecialchars($item['custom_image']) : ''; ?>"
                           placeholder="es: incantamedi o incantamedi.png">
                    <small>Leave empty to use VNUM-based image. Enter custom name (with or without .png)</small>
                </div>

                <!-- Sort Order -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-sort"></i>
                        Sort Order
                    </label>
                    <input type="number" class="form-input" name="sort_order"
                           value="<?php echo isset($item['sort_order']) ? $item['sort_order'] : $item['id']; ?>">
                    <small>Lower numbers appear first. Use this to reorder items in category.</small>
                </div>
            </div>
        </div>

        <!-- Discount & Promotion -->
        <div class="form-card">
            <div class="form-card-header">
                <i class="fas fa-percentage"></i>
                <h3>Discount & Promotion</h3>
            </div>
            <div class="form-card-body">
                <!-- Discount -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-tag"></i>
                        Discount (%)
                    </label>
                    <input type="number" class="form-input" name="discount" value="<?php echo $item['discount']; ?>" min="0" max="100">
                </div>

                <!-- Discount Duration -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-clock"></i>
                        Discount Duration
                    </label>
                    <div class="time-inputs">
                        <input type="number" name="discount_months" placeholder="Months" min="0" value="0">
                        <input type="number" name="discount_days" placeholder="Days" min="0" value="0">
                        <input type="number" name="discount_hours" placeholder="Hours" min="0" value="0">
                        <input type="number" name="discount_minutes" placeholder="Minutes" min="0" value="0">
                    </div>
                    <?php if ($discount_total_minutes > 0) { ?>
                    <small>Current: <?php echo floor($discount_total_minutes / (30*24*60)); ?>m <?php echo floor(($discount_total_minutes % (30*24*60)) / (24*60)); ?>d <?php echo floor(($discount_total_minutes % (24*60)) / 60); ?>h <?php echo $discount_total_minutes % 60; ?>min remaining</small>
                    <?php } ?>
                </div>

                <!-- Promotion Duration -->
                <div class="form-group">
                    <label class="form-label">
                        <i class="fas fa-fire"></i>
                        Promotion (Limited Time) Duration
                    </label>
                    <div class="time-inputs">
                        <input type="number" name="promotion_months" placeholder="Months" min="0" value="0">
                        <input type="number" name="promotion_days" placeholder="Days" min="0" value="0">
                        <input type="number" name="promotion_hours" placeholder="Hours" min="0" value="0">
                        <input type="number" name="promotion_minutes" placeholder="Minutes" min="0" value="0">
                    </div>
                    <?php if ($promotion_total_minutes > 0) { ?>
                    <small>Current: <?php echo floor($promotion_total_minutes / (30*24*60)); ?>m <?php echo floor(($promotion_total_minutes % (30*24*60)) / (24*60)); ?>d <?php echo floor(($promotion_total_minutes % (24*60)) / 60); ?>h <?php echo $promotion_total_minutes % 60; ?>min remaining</small>
                    <?php } ?>
                </div>
            </div>
        </div>

        <!-- Submit Buttons -->
        <div class="button-group">
            <button type="submit" name="update" class="btn-submit">
                <i class="fas fa-save"></i>
                Update Item
            </button>
            <a href="<?php print $shop_url . 'category/' . $item['category'] . '/'; ?>" class="btn-cancel">
                <i class="fas fa-times"></i>
                Cancel
            </a>
        </div>
    </form>

    <!-- Preview Card -->
    <div class="form-card" style="margin-top: 30px;">
        <div class="form-card-header">
            <i class="fas fa-eye"></i>
            <h3>Item Preview</h3>
        </div>
        <div class="form-card-body">
            <div class="item-preview">
                <div class="preview-image">
                    <img src="<?php print $shop_url; ?>images/items/<?php print get_item_image($item['vnum'], $item['id']); ?>.png"
                         alt="Item Preview"
                         onerror="this.src='<?php print $shop_url; ?>images/items/404.png'">
                </div>
                <div class="preview-info">
                    <h4><?php echo get_item_name($item['vnum']); ?></h4>
                    <p><strong>VNUM:</strong> <?php echo $item['vnum']; ?></p>
                    <p><strong>Price:</strong> <?php echo number_format($item['coins']); ?> MD</p>
                    <p><strong>Quantity:</strong> <?php echo $item['count']; ?></p>
                    <?php if (!empty($item['custom_image'])) { ?>
                    <p><strong>Custom Image:</strong> <?php echo htmlspecialchars($item['custom_image']); ?></p>
                    <?php } ?>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
.admin-form {
    display: flex;
    flex-direction: column;
    gap: 25px;
}

.form-card {
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 16px;
    overflow: hidden;
    box-shadow: var(--shadow-md);
}

.form-card-header {
    display: flex;
    align-items: center;
    gap: 12px;
    padding: 20px 25px;
    background: linear-gradient(135deg, rgba(220, 20, 60, 0.1) 0%, rgba(139, 0, 0, 0.1) 100%);
    border-bottom: 2px solid var(--one-scarlet);
}

.form-card-header i {
    font-size: 20px;
    color: var(--one-scarlet);
}

.form-card-header h3 {
    font-family: var(--font-heading);
    font-size: 18px;
    font-weight: 900;
    color: var(--text-primary);
    margin: 0;
    text-transform: uppercase;
    letter-spacing: 1px;
}

.form-card-body {
    padding: 25px;
}

.time-inputs {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 10px;
}

.time-inputs input {
    padding: 10px 12px !important;
}

.item-preview {
    display: flex;
    gap: 25px;
    align-items: center;
    padding: 20px;
    background: rgba(0, 0, 0, 0.2);
    border-radius: 12px;
}

.preview-image {
    width: 120px;
    height: 120px;
    flex-shrink: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: var(--glass-bg);
    border: 1px solid var(--glass-border);
    border-radius: 12px;
    padding: 10px;
}

.preview-image img {
    max-width: 100%;
    max-height: 100%;
    object-fit: contain;
    filter: drop-shadow(0 0 15px rgba(220, 20, 60, 0.5));
}

.preview-info {
    flex: 1;
}

.preview-info h4 {
    font-family: var(--font-heading);
    font-size: 20px;
    font-weight: 900;
    color: var(--text-primary);
    margin: 0 0 15px 0;
}

.preview-info p {
    color: var(--text-secondary);
    font-size: 14px;
    margin: 8px 0;
}

.preview-info p strong {
    color: var(--one-scarlet);
    font-weight: 700;
}

@media (max-width: 768px) {
    .time-inputs {
        grid-template-columns: 1fr 1fr;
    }

    .item-preview {
        flex-direction: column;
        text-align: center;
    }

    .preview-image {
        width: 100px;
        height: 100px;
    }
}
</style>
