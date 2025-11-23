<?php
try {
    $db = new PDO("sqlite:../include/db/site.db");
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $tables = $db->query("SELECT name FROM sqlite_master WHERE type='table'")->fetchAll(PDO::FETCH_COLUMN);

    foreach ($tables as $table) {
        echo "Table: $table\n";
        $columns = $db->query("PRAGMA table_info($table)")->fetchAll(PDO::FETCH_ASSOC);
        foreach ($columns as $col) {
            echo "  - " . $col['name'] . " (" . $col['type'] . ")\n";
        }
        echo "\n";
    }
} catch (PDOException $e) {
    echo "Error: " . $e->getMessage();
}
?>