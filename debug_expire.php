<?php
// Script di debug per verificare valori expire
error_reporting(E_ALL);
ini_set('display_errors', 1);

include 'include/functions/config.php';
require_once("include/classes/user.php");
$database = new USER($host, $user, $password);

echo "<h1>🔍 DEBUG EXPIRE VALUES</h1>";
echo "<pre>";

// 1. Verifica timezone server
echo "=== TIMEZONE INFO ===\n";
echo "Server Timezone: " . date_default_timezone_get() . "\n";
echo "Current Time: " . date('Y-m-d H:i:s') . "\n";
echo "Current Timestamp: " . time() . "\n";
echo "strtotime('now'): " . strtotime('now') . "\n";
echo "strtotime('now - 1 hour UTC'): " . strtotime('now - 1 hour UTC') . "\n";
$test_expire = strtotime("now - 1 hour UTC");
echo "Formatted: " . date('Y-m-d H:i:s', $test_expire) . "\n\n";

// 2. Controlla tutti gli item
echo "=== ALL ITEMS IN DATABASE ===\n";
$stmt = $database->runQuerySqlite('SELECT id, vnum, category, coins, expire, discount, discount_expire FROM item_shop_items ORDER BY id ASC');
$stmt->execute();
$items = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Total items: " . count($items) . "\n\n";

foreach($items as $item) {
    echo "ID: " . $item['id'] . " | VNUM: " . $item['vnum'] . " | Category: " . $item['category'] . "\n";
    echo "  Coins: " . $item['coins'] . " | Discount: " . $item['discount'] . "%\n";
    echo "  expire: " . $item['expire'];

    if($item['expire'] == 0) {
        echo " (PERMANENT)\n";
    } else if($item['expire'] < $test_expire) {
        echo " (EXPIRED - SHOULD BE DELETED!) - Date: " . date('Y-m-d H:i:s', $item['expire']) . "\n";
    } else {
        echo " (ACTIVE) - Expires: " . date('Y-m-d H:i:s', $item['expire']) . "\n";
    }

    echo "  discount_expire: " . $item['discount_expire'];
    if($item['discount_expire'] == 0) {
        echo " (NO DISCOUNT TIMER)\n";
    } else {
        echo " - Expires: " . date('Y-m-d H:i:s', $item['discount_expire']) . "\n";
    }
    echo "\n";
}

// 3. Simula autoDeletePromotions()
echo "=== SIMULATION: autoDeletePromotions() ===\n";
$expire = strtotime("now - 1 hour UTC");
echo "Would delete items WHERE expire != 0 AND expire < " . $expire . "\n";
echo "Query: DELETE FROM item_shop_items WHERE expire != 0 AND expire < " . $expire . "\n\n";

$stmt = $database->runQuerySqlite('SELECT id, vnum, expire FROM item_shop_items WHERE expire != 0 AND expire < ?');
$stmt->bindParam(1, $expire, PDO::PARAM_INT);
$stmt->execute();
$to_delete = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo "Items that WOULD BE DELETED: " . count($to_delete) . "\n";
foreach($to_delete as $del) {
    echo "  - ID: " . $del['id'] . " | VNUM: " . $del['vnum'] . " | expire: " . $del['expire'] . " (" . date('Y-m-d H:i:s', $del['expire']) . ")\n";
}

echo "\n";

// 4. Test timestamp math
echo "=== TIMESTAMP MATH TEST ===\n";
echo "If you create item with 1 day promotion:\n";
$test_expire_1d = strtotime("now +1 day - 1 hour UTC");
echo "  Expire would be: " . $test_expire_1d . " (" . date('Y-m-d H:i:s', $test_expire_1d) . ")\n";
echo "  In " . floor(($test_expire_1d - time()) / 3600) . " hours\n\n";

echo "If you create item with 1 hour promotion:\n";
$test_expire_1h = strtotime("now +1 hour - 1 hour UTC");
echo "  Expire would be: " . $test_expire_1h . " (" . date('Y-m-d H:i:s', $test_expire_1h) . ")\n";
echo "  Already expired? " . ($test_expire_1h < time() ? "YES! ⚠️" : "No") . "\n";

echo "</pre>";
?>
