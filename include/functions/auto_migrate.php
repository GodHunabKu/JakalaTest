<?php
/**
 * Auto-migration system
 * Aggiunge colonne al database automaticamente quando servono
 */

/**
 * Check if a column exists in SQLite item_shop_items table
 */
function check_sqlite_column($column_name) {
    global $database;

    try {
        $stmt = $database->runQuerySqlite("PRAGMA table_info(item_shop_items)");
        $stmt->execute();
        $columns = $stmt->fetchAll(PDO::FETCH_ASSOC);

        foreach($columns as $col) {
            if($col['name'] === $column_name) {
                return true;
            }
        }
        return false;
    } catch(Exception $e) {
        return false;
    }
}

function ensure_custom_image_column() {
    global $database;

    // Controlla se esiste già usando la funzione SQLite
    if (check_sqlite_column("custom_image")) {
        return true;
    }

    // Se non esiste, creala
    try {
        $database->execQuerySqlite("ALTER TABLE item_shop_items ADD COLUMN custom_image TEXT DEFAULT NULL");
        return true;
    } catch(Exception $e) {
        // Solo log se non è un errore di colonna duplicata
        if(strpos($e->getMessage(), 'duplicate column') === false) {
            error_log("Error creating custom_image column: " . $e->getMessage());
        }
        return false;
    }
}

function ensure_sort_order_column() {
    global $database;

    // Controlla se esiste già usando la funzione SQLite
    if (check_sqlite_column("sort_order")) {
        return true;
    }

    // Se non esiste, creala
    try {
        $database->execQuerySqlite("ALTER TABLE item_shop_items ADD COLUMN sort_order INTEGER DEFAULT 0");

        // Inizializza sort_order per item esistenti
        $database->execQuerySqlite("UPDATE item_shop_items SET sort_order = id WHERE sort_order = 0 OR sort_order IS NULL");

        return true;
    } catch(Exception $e) {
        // Solo log se non è un errore di colonna duplicata
        if(strpos($e->getMessage(), 'duplicate column') === false) {
            error_log("Error creating sort_order column: " . $e->getMessage());
        }
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
