<?php
require_once '../include/functions/header.php';

header('Content-Type: application/json');

$item_id = intval($_GET['id'] ?? 0);

if ($item_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'ID non valido']);
    exit;
}

try {
    $item = is_get_item($item_id);
    
    if (!$item || count($item) === 0) {
        throw new Exception('Item non trovato');
    }
    
    $item_data = $item[0];
    $item_name = !$item_name_db ? 
        get_item_name($item_data['vnum']) : 
        get_item_name_locale_name($item_data['vnum']);
    
    // Simula stats (personalizza secondo il tuo DB)
    $stats = [
        ['name' => 'ATK', 'value' => '+' . rand(50, 150)],
        ['name' => 'DEF', 'value' => '+' . rand(30, 100)],
        ['name' => 'HP', 'value' => '+' . rand(100, 500)]
    ];
    
    echo json_encode([
        'success' => true,
        'item' => [
            'id' => $item_data['id'],
            'vnum' => $item_data['vnum'],
            'name' => $item_name,
            'price' => $item_data['coins'],
            'discount' => $item_data['discount'],
            'image' => get_item_image($item_data['vnum']),
            'rarity' => 'rare', // Personalizza
            'stats' => $stats
        ]
    ]);
    
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}