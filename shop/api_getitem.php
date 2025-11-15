<?php
header('Content-Type: application/json; charset=utf-8');

// CONFIGURAZIONE DATABASE
$host = '81.180.203.241';
$dbname = 'player';
$user = 'dev';
$pass = '41uGl9eDUJij';

$response = ['success' => false];

if (!isset($_GET['vnum']) || !is_numeric($_GET['vnum'])) {
    $response['message'] = 'Parametro vnum mancante o non valido.';
    echo json_encode($response);
    exit;
}

$vnum = intval($_GET['vnum']);

try {
    $pdo = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8", $user, $pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $query = $pdo->prepare("
        SELECT 
            vnum, locale_name, type, subtype, gold, shop_buy_price,
            applytype0, applyvalue0,
            applytype1, applyvalue1,
            applytype2, applyvalue2,
            value0, value1, value2, value3, value4, value5
        FROM item_proto
        WHERE vnum = :vnum
        LIMIT 1
    ");
    $query->execute(['vnum' => $vnum]);
    $item = $query->fetch(PDO::FETCH_ASSOC);

    if ($item) {
        $response['success'] = true;
        $response['item'] = $item;
    } else {
        $response['message'] = 'Item non trovato nel database.';
    }

} catch (PDOException $e) {
    $response['message'] = 'Errore database: ' . $e->getMessage();
}

echo json_encode($response, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE);
?>
