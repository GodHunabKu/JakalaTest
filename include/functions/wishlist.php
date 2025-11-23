<?php
// Sistema Wishlist/Preferiti - File Based
// Ogni utente ha un file: data/wishlist_{account_id}.txt
// Formato: item_id|vnum|name|price (uno per riga)

function wishlist_add($account_id, $item_id, $vnum, $item_name, $price) {
    $file = __DIR__ . '/../../data/wishlist_' . $account_id . '.txt';

    // Crea directory se non esiste
    $dir = dirname($file);
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }

    // Leggi wishlist esistente
    $items = [];
    if (file_exists($file)) {
        $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            list($id, $v, $n, $p) = explode('|', $line);
            $items[$id] = ['item_id' => $id, 'vnum' => $v, 'name' => $n, 'price' => $p];
        }
    }

    // Aggiungi se non già presente
    if (!isset($items[$item_id])) {
        $items[$item_id] = ['item_id' => $item_id, 'vnum' => $vnum, 'name' => $item_name, 'price' => $price];

        // Salva
        $content = '';
        foreach ($items as $item) {
            $content .= $item['item_id'] . '|' . $item['vnum'] . '|' . $item['name'] . '|' . $item['price'] . "\n";
        }
        file_put_contents($file, $content);
        return true;
    }

    return false; // Già in wishlist
}

function wishlist_remove($account_id, $item_id) {
    $file = __DIR__ . '/../../data/wishlist_' . $account_id . '.txt';

    if (!file_exists($file)) {
        return false;
    }

    // Leggi wishlist
    $items = [];
    $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        list($id, $v, $n, $p) = explode('|', $line);
        if ($id != $item_id) {
            $items[$id] = ['item_id' => $id, 'vnum' => $v, 'name' => $n, 'price' => $p];
        }
    }

    // Salva
    $content = '';
    foreach ($items as $item) {
        $content .= $item['item_id'] . '|' . $item['vnum'] . '|' . $item['name'] . '|' . $item['price'] . "\n";
    }
    file_put_contents($file, $content);

    return true;
}

function wishlist_get($account_id) {
    $file = __DIR__ . '/../../data/wishlist_' . $account_id . '.txt';

    if (!file_exists($file)) {
        return [];
    }

    $items = [];
    $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        list($id, $v, $n, $p) = explode('|', $line);
        $items[] = ['item_id' => $id, 'vnum' => $v, 'name' => $n, 'price' => $p];
    }

    return $items;
}

function wishlist_has($account_id, $item_id) {
    $file = __DIR__ . '/../../data/wishlist_' . $account_id . '.txt';

    if (!file_exists($file)) {
        return false;
    }

    $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        list($id) = explode('|', $line);
        if ($id == $item_id) {
            return true;
        }
    }

    return false;
}

function wishlist_count($account_id) {
    $file = __DIR__ . '/../../data/wishlist_' . $account_id . '.txt';

    if (!file_exists($file)) {
        return 0;
    }

    $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    return count($lines);
}
?>
