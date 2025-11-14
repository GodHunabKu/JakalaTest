<?php
/**
 * Auto-migration system
 * Aggiunge colonne al database automaticamente quando servono
 */

function ensure_custom_image_column() {
    global $database;

    // Controlla se esiste già
    if (check_item_column("custom_image")) {
        return true;
    }

    // Se non esiste, creala
    try {
        $db = $database->getPDO();
        $db->exec("ALTER TABLE item_shop_items ADD COLUMN custom_image TEXT DEFAULT NULL");
        return true;
    } catch(Exception $e) {
        error_log("Error creating custom_image column: " . $e->getMessage());
        return false;
    }
}

function ensure_sort_order_column() {
    global $database;

    // Controlla se esiste già
    if (check_item_column("sort_order")) {
        return true;
    }

    // Se non esiste, creala
    try {
        $db = $database->getPDO();
        $db->exec("ALTER TABLE item_shop_items ADD COLUMN sort_order INTEGER DEFAULT 0");

        // Inizializza sort_order per item esistenti
        $db->exec("UPDATE item_shop_items SET sort_order = id WHERE sort_order = 0 OR sort_order IS NULL");

        return true;
    } catch(Exception $e) {
        error_log("Error creating sort_order column: " . $e->getMessage());
        return false;
    }
}

/**
 * Assicura che tutte le colonne necessarie esistano
 */
function ensure_database_schema() {
    ensure_custom_image_column();
    ensure_sort_order_column();
}
?>
