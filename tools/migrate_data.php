<?php
// tools/migrate_data.php

// Enable error reporting
error_reporting(E_ALL);
ini_set('display_errors', 1);

// 1. Connect to DB
try {
    $db_path = __DIR__ . '/../include/db/site.db';
    $db = new PDO("sqlite:" . $db_path);
    $db->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    echo "Connected to DB at $db_path\n";
} catch (PDOException $e) {
    die("DB Connection failed: " . $e->getMessage());
}

// Helper to parse SQL values
function parse_values($str) {
    // This is a basic parser. It assumes values are comma separated and strings are single-quoted.
    // It handles escaped quotes inside strings.
    $values = [];
    $len = strlen($str);
    $in_string = false;
    $current = '';
    
    for ($i = 0; $i < $len; $i++) {
        $char = $str[$i];
        
        if ($char === "'" && ($i === 0 || $str[$i-1] !== '\\')) {
            $in_string = !$in_string;
            $current .= $char;
        } elseif ($char === ',' && !$in_string) {
            $values[] = trim($current);
            $current = '';
        } else {
            $current .= $char;
        }
    }
    $values[] = trim($current);
    
    // Clean up quotes
    foreach ($values as &$val) {
        if (strpos($val, "'") === 0 && strrpos($val, "'") === strlen($val) - 1) {
            $val = substr($val, 1, -1);
            $val = str_replace("\\'", "'", $val); // Unescape
            $val = str_replace('\\"', '"', $val);
        }
        if ($val === 'NULL') $val = null;
    }
    
    return $values;
}

// 3. Migrate Categories
echo "Migrating Categories...\n";
$cats_path = __DIR__ . '/migration_source/shop_categories.sql';
if (!file_exists($cats_path)) die("File not found: $cats_path\n");
$cats_content = file_get_contents($cats_path);

// Clean table
try {
    $db->exec("DELETE FROM item_shop_categories");
    $db->exec("DELETE FROM sqlite_sequence WHERE name='item_shop_categories'");
} catch (Exception $e) {
    echo "Warning cleaning categories: " . $e->getMessage() . "\n";
}

preg_match_all('/INSERT INTO `shop_categories` VALUES \((.+?)\);/s', $cats_content, $matches);

$stmt = $db->prepare("INSERT INTO item_shop_categories (id, name, img) VALUES (?, ?, ?)");

foreach ($matches[1] as $row_str) {
    $row = parse_values($row_str);
    // Old: id, name, active, master_category_id, position, created_at, updated_at
    
    $id = $row[0];
    $name = $row[1];
    $img = 0; // Default icon
    
    try {
        $stmt->execute([$id, $name, $img]);
        echo "Inserted Category: $name ($id)\n";
    } catch (Exception $e) {
        echo "Error inserting category $id: " . $e->getMessage() . "\n";
    }
}

// 4. Migrate Items
echo "Migrating Items...\n";
$items_path = __DIR__ . '/migration_source/shop_items.sql';
if (!file_exists($items_path)) die("File not found: $items_path\n");
$items_content = file_get_contents($items_path);

// Clean table
try {
    $db->exec("DELETE FROM item_shop_items");
    $db->exec("DELETE FROM sqlite_sequence WHERE name='item_shop_items'");
} catch (Exception $e) {
    echo "Warning cleaning items: " . $e->getMessage() . "\n";
}

preg_match_all('/INSERT INTO `shop_items` VALUES \((.+?)\);/s', $items_content, $matches);

// Prepare insert statement with all necessary columns
// We map old columns to new columns and set defaults for missing ones
$sql = "INSERT INTO item_shop_items (
    id, category, vnum, count, coins, description, discount, discount_expire, 
    type, pay_type, expire, socket0, socket1, socket2, 
    attrtype0, attrvalue0, attrtype1, attrvalue1, attrtype2, attrvalue2, 
    attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6
) VALUES (
    ?, ?, ?, ?, ?, ?, ?, ?, 
    ?, ?, ?, ?, ?, ?, 
    0, 0, 0, 0, 0, 0, 
    0, 0, 0, 0, 0, 0, 0, 0
)";
$stmt = $db->prepare($sql);

foreach ($matches[1] as $row_str) {
    $row = parse_values($row_str);
    // Old: id, category_id, vnum, amount, cost, purchased_times, discount_end, discount, value0, description, hide_auto_desc, position, created_at, updated_at
    
    $id = $row[0];
    $category = $row[1];
    $vnum = $row[2];
    $count = $row[3];
    $coins = $row[4];
    $discount_end = ($row[6] && $row[6] !== 'NULL') ? strtotime($row[6]) : 0;
    $discount = $row[7];
    $description = $row[9];
    
    // Defaults
    $type = 1; // Standard item
    $pay_type = 'coins';
    $expire = 0;
    $socket0 = 0;
    $socket1 = 0;
    $socket2 = 0;
    
    try {
        $stmt->execute([
            $id, $category, $vnum, $count, $coins, $description, $discount, $discount_end,
            $type, $pay_type, $expire, $socket0, $socket1, $socket2
        ]);
        echo "Inserted Item: $vnum ($id)\n";
    } catch (Exception $e) {
        echo "Error inserting item $id: " . $e->getMessage() . "\n";
    }
}

// 5. Migrate Item Names
echo "Migrating Item Names...\n";
$item_list_path = __DIR__ . '/migration_source/item_list.txt';
if (file_exists($item_list_path)) {
    try {
        $db->exec("DELETE FROM items_names");
    } catch (Exception $e) {}
    
    // Check columns in items_names to be sure
    // Assuming en, it, de, es, fr, pt, ro, tr based on languages folder
    $stmt = $db->prepare("INSERT INTO items_names (id, en, it, de, es, fr, pt, ro, tr) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
    
    $lines = file($item_list_path);
    $count = 0;
    foreach ($lines as $line) {
        $line = trim($line);
        if (empty($line)) continue;
        
        $parts = preg_split('/\s+/', $line, 2);
        if (count($parts) >= 2) {
            $vnum = $parts[0];
            $name = $parts[1];
            
            try {
                $stmt->execute([$vnum, $name, $name, $name, $name, $name, $name, $name, $name]);
                $count++;
            } catch (Exception $e) {
                // Ignore duplicates or errors
            }
        }
    }
    echo "Inserted $count item names.\n";
} else {
    echo "item_list.txt not found.\n";
}

// 6. Copy Images
echo "Copying Images...\n";
// Images are assumed to be already uploaded to images/items/
// If you need to copy them from a source folder on the server, adjust this path.
// $src_dir = __DIR__ . '/migration_source/icon/item/';
// $dst_dir = __DIR__ . '/../images/items/';
echo "Skipping image copy (Images should be uploaded to images/items/)\n";

/*
if (!is_dir($dst_dir)) {
    mkdir($dst_dir, 0777, true);
}

$images = glob($src_dir . "*.png");
$img_count = 0;
if ($images) {
    foreach ($images as $img) {
        $filename = basename($img);
        if (copy($img, $dst_dir . $filename)) {
            $img_count++;
        }
    }
}
echo "Copied $img_count images.\n";
*/

echo "Migration Finished.\n";
?>