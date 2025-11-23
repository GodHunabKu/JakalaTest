<?php
session_start();
require_once '../include/functions/header.php';
require_once '../include/functions/wishlist.php';

header('Content-Type: application/json');

if (!is_loggedin()) {
    echo json_encode(['success' => false, 'message' => 'Non autenticato']);
    exit;
}

$data = json_decode(file_get_contents('php://input'), true);
$item_id = intval($data['item_id'] ?? 0);
$action = $data['action'] ?? 'add';

if ($item_id <= 0) {
    echo json_encode(['success' => false, 'message' => 'ID item non valido']);
    exit;
}

$account_id = get_account_id();

try {
    if ($action === 'add') {
        // Ottieni info item
        $item_info = is_get_item($item_id);
        if (!$item_info) {
            throw new Exception('Item non trovato');
        }
        
        $item_name = !$item_name_db ? 
            get_item_name($item_info[0]['vnum']) : 
            get_item_name_locale_name($item_info[0]['vnum']);
        
        $result = wishlist_add($account_id, $item_id, $item_info[0]['vnum'], $item_name, $item_info[0]['coins']);
    } else {
        $result = wishlist_remove($account_id, $item_id);
    }
    
    if ($result) {
        echo json_encode([
            'success' => true,
            'action' => $action,
            'count' => wishlist_count($account_id)
        ]);
    } else {
        throw new Exception('Operazione fallita');
    }
} catch (Exception $e) {
    echo json_encode([
        'success' => false,
        'message' => $e->getMessage()
    ]);
}