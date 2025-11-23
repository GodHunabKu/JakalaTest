<?php
// shop_admin.php - Funzioni di amministrazione e gestione categorie/paypal

function is_edit_category($id, $name, $img)
{
    global $database;

    $stmt = $database->runQuerySqlite("UPDATE item_shop_categories set name = ?, img = ? WHERE id=?");
    $stmt->bindParam(1, $name, PDO::PARAM_STR);
    $stmt->bindParam(2, $img, PDO::PARAM_INT);
    $stmt->bindParam(3, $id, PDO::PARAM_INT);
    $stmt->execute();

    admin_audit_log('edit_category', ['category_id' => $id, 'name' => $name, 'img' => $img]);
}

function is_add_category($name, $img)
{
    global $database;

    $stmt = $database->runQuerySqlite("INSERT INTO item_shop_categories (name, img) VALUES (?, ?)");
    $stmt->bindParam(1, $name, PDO::PARAM_STR);
    $stmt->bindParam(2, $img, PDO::PARAM_INT);
    $stmt->execute();

    $new_id = $database->getSqliteBonuslastInsertId();
    admin_audit_log('add_category', ['category_id' => $new_id, 'name' => $name, 'img' => $img]);
}

function is_delete_category($id)
{
    global $database;

    $sth = $database->runQuerySqlite("DELETE FROM item_shop_categories WHERE id = ?");
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();

    $sth = $database->runQuerySqlite("DELETE FROM item_shop_items WHERE category = ?");
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();

    admin_audit_log('delete_category', ['category_id' => $id]);
}

function is_delete_item($id)
{
    global $database;

    $sth = $database->runQuerySqlite('DELETE
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();

    $sth = $database->runQuerySqlite("DELETE FROM item_shop_bonuses WHERE id = ?");
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();

    admin_audit_log('delete_item', ['item_id' => $id]);
}

function get_all_paypal()
{
    global $database;
    
    $stmt = $database->runQuerySqlite("SELECT * FROM paypal ORDER BY id ASC");
    $stmt->execute();
    
    $result = $stmt->fetchAll();
    
    return $result;
}

function is_edit_paypal($id, $price, $coins)
{
    global $database;
    
    $stmt = $database->runQuerySqlite("UPDATE paypal set price = ?, coins = ? WHERE id=?");
    $stmt->bindParam(1, $price, PDO::PARAM_STR);
    $stmt->bindParam(2, $coins, PDO::PARAM_INT);
    $stmt->bindParam(3, $id, PDO::PARAM_INT);
    $stmt->execute();
}

function is_delete_paypal($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite("DELETE FROM paypal WHERE id = ?");
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
}

function is_add_paypal($price, $coins)
{
    global $database;
    
    $stmt = $database->runQuerySqlite("INSERT INTO paypal (price, coins) VALUES (?, ?)");
    $stmt->bindParam(1, $price, PDO::PARAM_STR);
    $stmt->bindParam(2, $coins, PDO::PARAM_INT);
    $stmt->execute();
}

function is_paypal_list()
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT *
        FROM paypal
        ORDER BY id ASC');
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result;
}

function is_check_paypal($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT id
        FROM paypal
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(count($result))
        return 1;
    else return 0;
}

function is_get_price($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT price
        FROM paypal
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result[0]['price'];
}

function is_get_coins($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT coins
        FROM paypal
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result[0]['coins'];
}

function check_txnid_paypal($tnxid)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT id
        FROM payments
        WHERE txnid = ?');
    $sth->bindParam(1, $tnxid, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(count($result))
        return 0;
    else return 1;
}

function check_price_paypal($price, $id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT price
        FROM paypal
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    if(count($result))
        if(floatval($price)==$result[0]['price'])
            return 1;
    return 0;
}

function updatePayments($data){
    global $database;
    
    if (is_array($data)) {
        $stmt = $database->runQuerySqlite('INSERT INTO payments (txnid, payment_amount, payment_status, itemid, createdtime) VALUES (?,?,?,?,?)');
        $stmt->execute(array($data['txn_id'], $data['payment_amount'], $data['payment_status'], $data['item_number'], date("Y-m-d H:i:s")));
    }
}

function get_coins_paypal($id_account, $id_paypal)
{
    global $database;

    $sth = $database->runQuerySqlite('SELECT coins
        FROM paypal
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id_paypal, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    $stmt = $database->runQueryAccount("UPDATE account SET coins = coins + ? WHERE id = ?");
    $stmt->bindParam(1, $result[0]['coins'], PDO::PARAM_INT);
    $stmt->bindParam(2, $id_account, PDO::PARAM_INT);
    $stmt->execute();
}

function is_set_item_discount($id, $discount, $expire)
{
    global $database;
    
    $stmt = $database->runQuerySqlite("UPDATE item_shop_items set discount = ?, discount_expire = ? WHERE id=?");
    $stmt->bindParam(1, $discount, PDO::PARAM_STR);
    $stmt->bindParam(2, $expire, PDO::PARAM_INT);
    $stmt->bindParam(3, $id, PDO::PARAM_INT);
    $stmt->execute();
}

function is_edit_item($id, $vnum, $count, $coins, $description)
{
    global $database;
    
    $stmt = $database->runQuerySqlite("UPDATE item_shop_items SET vnum = ?, count = ?, coins = ?, description = ? WHERE id = ?");
    $stmt->bindParam(1, $vnum, PDO::PARAM_INT);
    $stmt->bindParam(2, $count, PDO::PARAM_INT);
    $stmt->bindParam(3, $coins, PDO::PARAM_INT);
    $stmt->bindParam(4, $description, PDO::PARAM_STR);
    $stmt->bindParam(5, $id, PDO::PARAM_INT);
    $stmt->execute();
}
?>