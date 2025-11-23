<?php
// Sistema semplice per tracciare gli item più acquistati
// Ogni riga: vnum|nome|prezzo|contatore

function track_purchase($vnum, $item_name, $price) {
    $file = __DIR__ . '/../../data/popular_items.txt';

    // Crea directory se non esiste
    $dir = dirname($file);
    if (!is_dir($dir)) {
        mkdir($dir, 0755, true);
    }

    // Leggi file esistente
    $items = [];
    if (file_exists($file)) {
        $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            list($v, $n, $p, $c) = explode('|', $line);
            $items[$v] = ['vnum' => $v, 'name' => $n, 'price' => $p, 'count' => (int)$c];
        }
    }

    // Aggiorna o aggiungi
    if (isset($items[$vnum])) {
        $items[$vnum]['count']++;
    } else {
        $items[$vnum] = ['vnum' => $vnum, 'name' => $item_name, 'price' => $price, 'count' => 1];
    }

    // Salva
    $content = '';
    foreach ($items as $item) {
        $content .= $item['vnum'] . '|' . $item['name'] . '|' . $item['price'] . '|' . $item['count'] . "\n";
    }
    file_put_contents($file, $content);
}

function get_most_popular($limit = 5) {
    $file = __DIR__ . '/../../data/popular_items.txt';

    if (!file_exists($file)) {
        return [];
    }

    $items = [];
    $lines = file($file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    foreach ($lines as $line) {
        list($v, $n, $p, $c) = explode('|', $line);
        $items[] = ['vnum' => $v, 'name' => $n, 'price' => $p, 'count' => (int)$c];
    }

    // Ordina per contatore
    usort($items, function($a, $b) {
        return $b['count'] - $a['count'];
    });

    return array_slice($items, 0, $limit);
}
?>
