<?php
/**
 * Script di migrazione database - Aggiunta campi per edit e riordinamento
 * Aggiunge: custom_image (testo) e sort_order (intero)
 */

try {
    // Apri connessione al database SQLite
    $db = new PDO('sqlite:' . __DIR__ . '/site.db');
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    echo "=== Database Migration - Items Table ===\n\n";

    // Check se i campi esistono già
    $columns = $db->query("PRAGMA table_info(items)")->fetchAll(PDO::FETCH_ASSOC);
    $existing_columns = array_column($columns, 'name');

    $needs_custom_image = !in_array('custom_image', $existing_columns);
    $needs_sort_order = !in_array('sort_order', $existing_columns);

    if (!$needs_custom_image && !$needs_sort_order) {
        echo "✅ Tutti i campi esistono già. Nessuna modifica necessaria.\n";
        exit(0);
    }

    // Inizia transaction
    $db->beginTransaction();

    // Aggiungi custom_image se non esiste
    if ($needs_custom_image) {
        echo "➕ Aggiunta colonna 'custom_image'...\n";
        $db->exec("ALTER TABLE items ADD COLUMN custom_image TEXT DEFAULT NULL");
        echo "✅ Colonna 'custom_image' aggiunta con successo.\n";
    } else {
        echo "⏭️  Colonna 'custom_image' già esistente.\n";
    }

    // Aggiungi sort_order se non esiste
    if ($needs_sort_order) {
        echo "➕ Aggiunta colonna 'sort_order'...\n";
        $db->exec("ALTER TABLE items ADD COLUMN sort_order INTEGER DEFAULT 0");
        echo "✅ Colonna 'sort_order' aggiunta con successo.\n";

        // Imposta valori iniziali di sort_order basati sull'ID
        echo "🔄 Inizializzazione valori sort_order...\n";
        $db->exec("UPDATE items SET sort_order = id WHERE sort_order = 0 OR sort_order IS NULL");
        echo "✅ Valori sort_order inizializzati.\n";
    } else {
        echo "⏭️  Colonna 'sort_order' già esistente.\n";
    }

    // Commit transaction
    $db->commit();

    echo "\n=== Migrazione completata con successo! ===\n\n";

    // Mostra struttura finale
    echo "Struttura finale tabella items:\n";
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n";
    $columns = $db->query("PRAGMA table_info(items)")->fetchAll(PDO::FETCH_ASSOC);
    foreach ($columns as $col) {
        echo sprintf("%-20s %s\n", $col['name'], $col['type']);
    }

} catch (PDOException $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    echo "❌ ERRORE: " . $e->getMessage() . "\n";
    exit(1);
}
?>
