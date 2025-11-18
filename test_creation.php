<?php
// Test script per vedere cosa succede quando crei un item
error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h1>🧪 TEST ITEM CREATION LOGIC</h1>";
echo "<pre>";

// Simula POST senza promotion (tutti campi a 0)
$_POST = [
    'promotion_months' => '0',
    'promotion_days' => '0',
    'promotion_hours' => '0',
    'promotion_minutes' => '0'
];

echo "=== SIMULATION: Creating item WITHOUT promotion ===\n";
echo "POST data:\n";
print_r($_POST);

// Replica la logica di add_items.php
$expire = 0;
$promotion_months = isset($_POST['promotion_months']) ? intval($_POST['promotion_months']) : 0;
$promotion_days = isset($_POST['promotion_days']) ? intval($_POST['promotion_days']) : 0;
$promotion_hours = isset($_POST['promotion_hours']) ? intval($_POST['promotion_hours']) : 0;
$promotion_minutes = isset($_POST['promotion_minutes']) ? intval($_POST['promotion_minutes']) : 0;

echo "\nExtracted values:\n";
echo "  promotion_months: $promotion_months\n";
echo "  promotion_days: $promotion_days\n";
echo "  promotion_hours: $promotion_hours\n";
echo "  promotion_minutes: $promotion_minutes\n";

echo "\nCondition check:\n";
echo "  if(\$promotion_months > 0 || \$promotion_days > 0 || \$promotion_hours > 0 || \$promotion_minutes > 0)\n";

if($promotion_months > 0 || $promotion_days > 0 || $promotion_hours > 0 || $promotion_minutes > 0) {
    echo "  → TRUE: Will calculate expire timestamp\n";
    $expire = strtotime("now +{$promotion_months} month +{$promotion_days} day +{$promotion_hours} hours +{$promotion_minutes} minute - 1 hour UTC");
    echo "  → expire = $expire (" . date('Y-m-d H:i:s', $expire) . ")\n";
} else {
    echo "  → FALSE: expire remains 0 (permanent item)\n";
    echo "  → expire = $expire (PERMANENT)\n";
}

echo "\n=== SIMULATION: Creating item WITH 1 hour promotion ===\n";
$_POST = [
    'promotion_months' => '0',
    'promotion_days' => '0',
    'promotion_hours' => '1',
    'promotion_minutes' => '0'
];

echo "POST data:\n";
print_r($_POST);

$expire = 0;
$promotion_months = isset($_POST['promotion_months']) ? intval($_POST['promotion_months']) : 0;
$promotion_days = isset($_POST['promotion_days']) ? intval($_POST['promotion_days']) : 0;
$promotion_hours = isset($_POST['promotion_hours']) ? intval($_POST['promotion_hours']) : 0;
$promotion_minutes = isset($_POST['promotion_minutes']) ? intval($_POST['promotion_minutes']) : 0;

echo "\nExtracted values:\n";
echo "  promotion_months: $promotion_months\n";
echo "  promotion_days: $promotion_days\n";
echo "  promotion_hours: $promotion_hours\n";
echo "  promotion_minutes: $promotion_minutes\n";

if($promotion_months > 0 || $promotion_days > 0 || $promotion_hours > 0 || $promotion_minutes > 0) {
    echo "\nCondition: TRUE\n";
    $expire = strtotime("now +{$promotion_months} month +{$promotion_days} day +{$promotion_hours} hours +{$promotion_minutes} minute - 1 hour UTC");
    echo "expire = $expire\n";
    echo "Formatted: " . date('Y-m-d H:i:s', $expire) . "\n";

    $now = time();
    echo "\nCurrent time: $now (" . date('Y-m-d H:i:s', $now) . ")\n";
    echo "Difference: " . ($expire - $now) . " seconds\n";

    if($expire <= $now) {
        echo "⚠️ WARNING: expire is in the PAST or NOW! Item will be deleted immediately!\n";
    } else {
        echo "✓ OK: expire is in the future (" . floor(($expire - $now) / 60) . " minutes)\n";
    }
}

echo "\n=== TEST: autoDeletePromotions() logic ===\n";
$test_expire_check = strtotime("now - 1 hour UTC");
echo "autoDeletePromotions() uses: strtotime('now - 1 hour UTC')\n";
echo "Value: $test_expire_check (" . date('Y-m-d H:i:s', $test_expire_check) . ")\n";
echo "\nQuery: DELETE FROM item_shop_items WHERE expire != 0 AND expire < $test_expire_check\n";

echo "\nTest items:\n";
$test_items = [
    ['id' => 1, 'expire' => 0, 'note' => 'Permanent item'],
    ['id' => 2, 'expire' => time() - 3600, 'note' => 'Expired 1 hour ago'],
    ['id' => 3, 'expire' => time() + 3600, 'note' => 'Expires in 1 hour'],
    ['id' => 4, 'expire' => time(), 'note' => 'Expires NOW']
];

foreach($test_items as $item) {
    echo "\nItem ID {$item['id']} - {$item['note']}\n";
    echo "  expire: {$item['expire']}";
    if($item['expire'] > 0) {
        echo " (" . date('Y-m-d H:i:s', $item['expire']) . ")";
    }
    echo "\n";

    // Check autoDeletePromotions() condition
    $would_delete = ($item['expire'] != 0 && $item['expire'] < $test_expire_check);
    echo "  expire != 0: " . ($item['expire'] != 0 ? 'TRUE' : 'FALSE') . "\n";
    echo "  expire < $test_expire_check: " . ($item['expire'] < $test_expire_check ? 'TRUE' : 'FALSE') . "\n";
    echo "  Would be DELETED: " . ($would_delete ? '❌ YES' : '✓ NO') . "\n";
}

echo "\n=== TIMEZONE INFO ===\n";
echo "PHP default timezone: " . date_default_timezone_get() . "\n";
echo "Server time: " . date('Y-m-d H:i:s') . "\n";
echo "time(): " . time() . "\n";
echo "strtotime('now'): " . strtotime('now') . "\n";
echo "strtotime('now UTC'): " . strtotime('now UTC') . "\n";
echo "strtotime('now - 1 hour UTC'): " . strtotime('now - 1 hour UTC') . "\n";

echo "</pre>";
?>
