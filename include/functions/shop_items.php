<?php
// shop_items.php - Gestione Item, Ricerca e Bonus

function getItemSize($code) {
    global $database;

    $sth = $database->runQuerySqlite('SELECT size
        FROM items_details
        WHERE id = ?');
    $sth->bindParam(1, $code, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    if(isset($result[0]['size']))
        return $result[0]['size'];
    else return 3;
}

function new_item_position($new_item)
{
    global $database;
        
    $sth = $database->runQueryPlayer('SELECT pos, vnum
        FROM item
        WHERE owner_id=? AND window="MALL" ORDER by pos ASC');
    $sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    $used = $items_used = $used_check = array();
    
    foreach( $result as $row ) {
        $used_check[] = $row['pos'];
        $used[$row['pos']] = 1;
        $items_used[$row['pos']] = $row['vnum'];
    }
    $used_check = array_unique($used_check);

    $free = -1;
    
    for($i=0; $i<45; $i++){
        if(!in_array($i,$used_check)){
            $ok = true;
            
            if($i>4 && $i<10)
            {
                if(array_key_exists($i-5, $used) && getItemSize($items_used[$i-5])>1)
                    $ok = false;
            }
            else if($i>9 && $i<40)
            {
                if(array_key_exists($i-5, $used) && getItemSize($items_used[$i-5])>1)
                    $ok = false;
                
                if(array_key_exists($i-10, $used) && getItemSize($items_used[$i-10])>2)
                    $ok = false;
            }
            else if($i>39 && $i<45 && getItemSize($new_item)>1)
                    $ok = false;
            
            if($ok)
                return $i;
        }
    }
    
    return $free;
}

function check_item_sash($id)
{
    if($id > 85000 && $id < 90000)
        return true;
    else return false;
}

function check_item_stone($id)
{
    if($id >= 28000 && $id <= 28960)
        return true;
    else return false;
}

function get_item_name_locale_name($id)
{
    global $database;
    
    $stmt = $database->runQueryPlayer('SELECT locale_name
        FROM item_proto
        WHERE vnum = ?');
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    return utf8_encode($result['locale_name']);
}

function get_item_name($id)
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT '.$language_code.'
        FROM items_names
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(isset($result[0][$language_code]))
        return $result[0][$language_code];
    else return 'No name';
}

function return_item_name($id)
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT '.$language_code.'
        FROM items_names
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result[0][$language_code];
}

function get_bonus_name($id, $value)
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT '.$language_code.'
        FROM items_bonuses
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return str_replace("[n]", '<font color="red"><b>'.$value.'</b></font>', $result[0][$language_code]);
}

function get_item_type($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT type
        FROM items_details
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(isset($result[0]['type']))
        return $result[0]['type'];
    else return 'NOT_FOUND';
}

function get_item_lvl($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT lvl
        FROM items_details
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    if(isset($result[0]['lvl']) && $result[0]['lvl']<=105)
        return $result[0]['lvl'];
    else return 0;
}

function get_item_stones_market($id)
{
    global $database, $shop_url, $item_name_db;
    
    $sth = $database->runQuerySqlite('SELECT socket0, socket1, socket2
        FROM item_shop_items
        WHERE id = ?');
    
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    if((check_item_stone($result[0]['socket0'])))
    {
        print '<div class="alert alert-info" style="border-radius: 0!important; margin-bottom: 0!important;">
                    <div class="row">';
                    
        for($i=0;$i<=2;$i++)
            if((check_item_stone($result[0]['socket'.$i])))
            {
                if(!$item_name_db)
                    $item_name = get_item_name($result[0]['socket'.$i]);
                else 
                    $item_name = get_item_name_locale_name($result[0]['socket'.$i]);
                print '<div class="col-md-4">
                            <img src="'.$shop_url.'images/items/'. get_item_image($result[0]['socket'.$i]) .'.png">
                            <p>'. $item_name .'</p>
                        </div>';
            }
        print '</div>
        </div>';
    }
}

function is_categories_list()
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT *
        FROM item_shop_categories
        ORDER BY id ASC');
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result;
}

function is_get_category_name($category)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT name
        FROM item_shop_categories
        WHERE id = ?');
    $sth->bindParam(1, $category, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result[0]['name'];
}

function is_check_category($category)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT id
        FROM item_shop_categories
        WHERE id = ?');
    $sth->bindParam(1, $category, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(count($result))
        return 1;
    else return 0;
}

function is_check_item($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT id
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(count($result))
        return 1;
    else return 0;
}

function is_item_select($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT id, category, type, description, pay_type, coins, count, vnum, socket0, socket1, socket2, expire, item_unique, discount, discount_expire
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result;
}

function is_items_list($category)
{
    global $database;

    $sth = $database->runQuerySqlite('SELECT id, type, pay_type, coins, vnum, expire, discount, description
        FROM item_shop_items
        WHERE category = ? ORDER BY id ASC');
    $sth->bindParam(1, $category, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    return $result;
}

function is_items_list_paginated($category, $page = 1, $per_page = 12, $filters = [])
{
    global $database;

    $offset = ($page - 1) * $per_page;

    $where = ['category = ?'];
    $params = [$category];
    $param_types = [PDO::PARAM_INT];

    if (!empty($filters['price_min'])) {
        $where[] = 'coins >= ?';
        $params[] = $filters['price_min'];
        $param_types[] = PDO::PARAM_INT;
    }

    if (!empty($filters['price_max'])) {
        $where[] = 'coins <= ?';
        $params[] = $filters['price_max'];
        $param_types[] = PDO::PARAM_INT;
    }

    if (!empty($filters['only_discount'])) {
        $where[] = 'discount > 0';
    }

    if (!empty($filters['search'])) {
        $where[] = 'vnum IN (SELECT vnum FROM item_proto WHERE name LIKE ?)';
        $params[] = '%' . $filters['search'] . '%';
        $param_types[] = PDO::PARAM_STR;
    }

    $where_clause = implode(' AND ', $where);

    $order = 'id DESC';
    if (!empty($filters['order_by'])) {
        switch($filters['order_by']) {
            case 'price_asc': $order = 'coins ASC'; break;
            case 'price_desc': $order = 'coins DESC'; break;
            case 'discount': $order = 'discount DESC'; break;
            case 'name': $order = 'vnum ASC'; break;
            default: $order = 'id DESC';
        }
    }

    $sql = "SELECT id, type, pay_type, coins, vnum, expire, discount
            FROM item_shop_items
            WHERE $where_clause
            ORDER BY $order
            LIMIT ? OFFSET ?";

    $sth = $database->runQuerySqlite($sql);

    foreach ($params as $i => $param) {
        $sth->bindParam($i + 1, $params[$i], $param_types[$i]);
    }
    $sth->bindParam(count($params) + 1, $per_page, PDO::PARAM_INT);
    $sth->bindParam(count($params) + 2, $offset, PDO::PARAM_INT);

    $sth->execute();
    return $sth->fetchAll();
}

function is_items_count($category, $filters = [])
{
    global $database;

    $where = ['category = ?'];
    $params = [$category];
    $param_types = [PDO::PARAM_INT];

    if (!empty($filters['price_min'])) {
        $where[] = 'coins >= ?';
        $params[] = $filters['price_min'];
        $param_types[] = PDO::PARAM_INT;
    }

    if (!empty($filters['price_max'])) {
        $where[] = 'coins <= ?';
        $params[] = $filters['price_max'];
        $param_types[] = PDO::PARAM_INT;
    }

    if (!empty($filters['only_discount'])) {
        $where[] = 'discount > 0';
    }

    if (!empty($filters['search'])) {
        $where[] = 'vnum IN (SELECT vnum FROM item_proto WHERE name LIKE ?)';
        $params[] = '%' . $filters['search'] . '%';
        $param_types[] = PDO::PARAM_STR;
    }

    $where_clause = implode(' AND ', $where);
    $sql = "SELECT COUNT(*) as total FROM item_shop_items WHERE $where_clause";

    $sth = $database->runQuerySqlite($sql);
    foreach ($params as $i => $param) {
        $sth->bindParam($i + 1, $params[$i], $param_types[$i]);
    }
    $sth->execute();
    $result = $sth->fetch();

    return $result['total'];
}

// OPTIMIZED SEARCH FUNCTION (SQL BASED)
function is_search_items_global($search_term, $page = 1, $per_page = 12)
{
    global $database, $language_code;

    $offset = ($page - 1) * $per_page;
    $results = [];

    // Se è numerico, cerca per VNUM
    if (is_numeric($search_term)) {
        $sql = "SELECT id, type, pay_type, coins, vnum, expire, discount, category
                FROM item_shop_items
                WHERE vnum = ?
                ORDER BY id DESC
                LIMIT ? OFFSET ?";
        $sth = $database->runQuerySqlite($sql);
        $sth->bindParam(1, $search_term, PDO::PARAM_INT);
        $sth->bindParam(2, $per_page, PDO::PARAM_INT);
        $sth->bindParam(3, $offset, PDO::PARAM_INT);
        $sth->execute();
        $results = $sth->fetchAll();
    } else {
        // Cerca per nome usando JOIN con items_names
        // Nota: items_names è in SQLite, item_shop_items è in SQLite. Perfetto.
        $search_like = '%' . $search_term . '%';
        
        // Costruiamo la query dinamica in base alla lingua
        $lang_col = preg_replace('/[^a-z]/', '', $language_code); // Sanitize
        
        $sql = "SELECT i.id, i.type, i.pay_type, i.coins, i.vnum, i.expire, i.discount, i.category
                FROM item_shop_items i
                LEFT JOIN items_names n ON i.vnum = n.id
                WHERE n.$lang_col LIKE ?
                ORDER BY i.id DESC
                LIMIT ? OFFSET ?";
                
        $sth = $database->runQuerySqlite($sql);
        $sth->bindParam(1, $search_like, PDO::PARAM_STR);
        $sth->bindParam(2, $per_page, PDO::PARAM_INT);
        $sth->bindParam(3, $offset, PDO::PARAM_INT);
        $sth->execute();
        $results = $sth->fetchAll();
    }

    return $results;
}

function is_search_items_count($search_term)
{
    global $database, $language_code;

    if (is_numeric($search_term)) {
        $sql = "SELECT COUNT(*) as total FROM item_shop_items WHERE vnum = ?";
        $sth = $database->runQuerySqlite($sql);
        $sth->bindParam(1, $search_term, PDO::PARAM_INT);
        $sth->execute();
        $result = $sth->fetch();
        return $result['total'];
    } else {
        $search_like = '%' . $search_term . '%';
        $lang_col = preg_replace('/[^a-z]/', '', $language_code);
        
        $sql = "SELECT COUNT(*) as total
                FROM item_shop_items i
                LEFT JOIN items_names n ON i.vnum = n.id
                WHERE n.$lang_col LIKE ?";
                
        $sth = $database->runQuerySqlite($sql);
        $sth->bindParam(1, $search_like, PDO::PARAM_STR);
        $sth->execute();
        $result = $sth->fetch();
        return $result['total'];
    }
}

function is_get_related_items($category, $current_item_id, $limit = 6)
{
    global $database;

    $sth = $database->runQuerySqlite('SELECT id, type, pay_type, coins, vnum, expire, discount
        FROM item_shop_items
        WHERE category = ? AND id != ?
        ORDER BY RANDOM()
        LIMIT ?');
    $sth->bindParam(1, $category, PDO::PARAM_INT);
    $sth->bindParam(2, $current_item_id, PDO::PARAM_INT);
    $sth->bindParam(3, $limit, PDO::PARAM_INT);
    $sth->execute();

    return $sth->fetchAll();
}

function is_get_max_item_id()
{
    global $database;

    try {
        $sth = $database->runQuerySqlite('SELECT MAX(id) as max_id FROM item_shop_items');
        $sth->execute();
        $result = $sth->fetch();

        return $result && isset($result['max_id']) ? intval($result['max_id']) : 0;
    } catch (Exception $e) {
        return 0;
    }
}

function is_item_new($item_id)
{
    static $max_id = null;

    if ($max_id === null) {
        $max_id = is_get_max_item_id();
    }
    return ($max_id > 0 && $item_id > ($max_id - 20));
}

function is_get_newest_items($limit = 12)
{
    global $database;

    try {
        $sth = $database->runQuerySqlite('SELECT id, type, pay_type, coins, vnum, expire, discount, category
            FROM item_shop_items
            ORDER BY id DESC
            LIMIT ?');
        $sth->bindParam(1, $limit, PDO::PARAM_INT);
        $sth->execute();

        $results = $sth->fetchAll();
        return is_array($results) ? $results : array();
    } catch (Exception $e) {
        return array();
    }
}

function is_get_bonuses()
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT '.$language_code.', id
        FROM items_bonuses');
    $sth->execute();
    $result = $sth->fetchAll();
    
    foreach( $result as $row ) {
        print '<option value='.$row['id'].'>'.str_replace("[n]", 'XXX', $row[$language_code]).'</option>';
    }
}

function is_get_item($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT attrtype0, attrvalue0, attrtype1, attrvalue1,
        attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4,
        attrtype5, attrvalue5, attrtype6, attrvalue6
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    for($i=0;$i<=6;$i++)
        if($result[0]['attrtype'.$i])
        {
            print '<li class="list-group-item"><center>';
            print get_bonus_name($result[0]['attrtype'.$i], $result[0]['attrvalue'.$i]);
            print '</center></li>';
        }
}

function is_get_sash_bonuses($id)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT applytype0, applyvalue0, applytype1, applyvalue1,
        applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4,
        applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    $a=$m=0;
    
    for($i=0;$i<=7;$i++)
        if($result[0]['applytype'.$i])
        {
            if($result[0]['applytype'.$i]==53 && !$a)
            {
                print '<li class="list-group-item"><center>';
                print str_replace('+', '', get_bonus_name($result[0]['applytype'.$i], $result[0]['applyvalue'.$i]));
                $a++;
            }
            else if($result[0]['applytype'.$i]==53 && $a)
            {
                print ' - <font color="red"><b>'.$result[0]['applyvalue'.$i].'</b></font>';
                print '<li class="list-group-item"><center>';
            }
            else if($result[0]['applytype'.$i]==55 && !$m)
            {
                print '<li class="list-group-item"><center>';
                print str_replace('+', '', get_bonus_name($result[0]['applytype'.$i], $result[0]['applyvalue'.$i]));
                $m++;
            }
            else if($result[0]['applytype'.$i]==55 && $m)
            {
                print ' - <font color="red"><b>'.$result[0]['applyvalue'.$i].'</b></font>';
                print '<li class="list-group-item"><center>';
            }
            else
            {
                print '<li class="list-group-item"><center>';
                print get_bonus_name($result[0]['applytype'.$i], $result[0]['applyvalue'.$i]);
                print '</center></li>';
            }
        }
}

function is_get_sash_absorption($id)
{
    global $database;
    
    $absorption_settings = get_settings_time(3);
    
    $sth = $database->runQuerySqlite('SELECT socket1
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    return $result[0]['socket'.$absorption_settings];
}

function is_get_item_time($id)
{
    global $database, $lang_shop;
    
    $sth = $database->runQuerySqlite('SELECT socket0, socket1, socket2
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    for($i=0;$i<=2;$i++)
        if($result[0]['socket'.$i])
            {
                $minutes = $result[0]['socket'.$i];
                $d = floor($minutes / 1440);
                $h = floor(($minutes - $d * 1440) / 60);
                $m = $minutes - ($d * 1440) - ($h * 60);
                if($d)
                    print $d.' '.$lang_shop['days'].' ';
                if($h)
                    print $h.' '.$lang_shop['hours'].' ';
                if($m)
                    print $m.' '.$lang_shop['minutes'].' ';
            }
}

function is_buy_item($id, $buy_bonuses)
{
    global $database;
    
    $sth = $database->runQuerySqlite('SELECT *
        FROM item_shop_items
        WHERE id = ?');
    $sth->bindParam(1, $id, PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    $item_position = new_item_position($result[0]['vnum']);
    
    if($item_position == -1)
        return false;
    
    $success = false;
    if($result[0]['type']==3)
    {
        $bonuses = is_get_bonus_selection($id);
        
        $final_bonuses = array();
        for($i=0;$i<7;$i++)
            $final_bonuses['attrtype'.$i]=$final_bonuses['attrvalue'.$i] = 0;
        
        foreach($buy_bonuses as $key => $bonus)
        {
            $final_bonuses['attrtype'.$key] = $bonus;
            $final_bonuses['attrvalue'.$key] = $bonuses['bonus'.$bonus];
        }
        
        $stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
        if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, 1, $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],
                            $final_bonuses['attrtype0'], $final_bonuses['attrvalue0'], $final_bonuses['attrtype1'], $final_bonuses['attrvalue1'], $final_bonuses['attrtype2'], $final_bonuses['attrvalue2'], 
                            $final_bonuses['attrtype3'], $final_bonuses['attrvalue3'], $final_bonuses['attrtype4'], $final_bonuses['attrvalue4'], $final_bonuses['attrtype5'], $final_bonuses['attrvalue5'], 
                            $final_bonuses['attrtype6'], $final_bonuses['attrvalue6'])))
        $success = true;
    } else
    {
        $time2_settings = get_settings_time(2);
        
        if(check_item_column("applytype0"))
        {
            if($result[0]['type']==1)
            {
                $result[0]['socket'.$time2_settings] = time() + 60 * intval($result[0]['socket'.$time2_settings]);

                $stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
                if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],
                                    $result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 
                                    $result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 
                                    $result[0]['attrtype6'], $result[0]['attrvalue6'], 
                                    $result[0]['applytype0'], $result[0]['applyvalue0'], $result[0]['applytype1'], $result[0]['applyvalue1'], $result[0]['applytype2'], $result[0]['applyvalue2'], 
                                    $result[0]['applytype3'], $result[0]['applyvalue3'], $result[0]['applytype4'], $result[0]['applyvalue4'], $result[0]['applytype5'], $result[0]['applyvalue5'], 
                                    $result[0]['applytype6'], $result[0]['applyvalue6'], $result[0]['applytype7'], $result[0]['applyvalue7'])))
                                    $success = true;
            } else {
                $stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6, applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2, applytype3, applyvalue3, applytype4, applyvalue4, applytype5, applyvalue5, applytype6, applyvalue6, applytype7, applyvalue7) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
                if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],
                                    $result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 
                                    $result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 
                                    $result[0]['attrtype6'], $result[0]['attrvalue6'], 
                                    $result[0]['applytype0'], $result[0]['applyvalue0'], $result[0]['applytype1'], $result[0]['applyvalue1'], $result[0]['applytype2'], $result[0]['applyvalue2'], 
                                    $result[0]['applytype3'], $result[0]['applyvalue3'], $result[0]['applytype4'], $result[0]['applyvalue4'], $result[0]['applytype5'], $result[0]['applyvalue5'], 
                                    $result[0]['applytype6'], $result[0]['applyvalue6'], $result[0]['applytype7'], $result[0]['applyvalue7'])))
                                    $success = true;
            }
        }
        else
        {
            if($result[0]['type']==1)
            {
                $result[0]['socket'.$time2_settings] = time() + 60 * intval($result[0]['socket'.$time2_settings]);
                
                $stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
                if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],
                                    $result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 
                                    $result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 
                                    $result[0]['attrtype6'], $result[0]['attrvalue6'])))
                                    $success = true;
            } else {
                $stmt = $database->runQueryPlayer('INSERT INTO item (owner_id, window, pos, count, vnum, socket0, socket1, socket2, attrtype0, attrvalue0, attrtype1 , attrvalue1, attrtype2, attrvalue2, attrtype3, attrvalue3, attrtype4, attrvalue4, attrtype5, attrvalue5, attrtype6, attrvalue6) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)');
                if($stmt->execute(array($_SESSION['id'], "MALL", $item_position, $result[0]['count'], $result[0]['vnum'], $result[0]['socket0'], $result[0]['socket1'], $result[0]['socket2'],
                                    $result[0]['attrtype0'], $result[0]['attrvalue0'], $result[0]['attrtype1'], $result[0]['attrvalue1'], $result[0]['attrtype2'], $result[0]['attrvalue2'], 
                                    $result[0]['attrtype3'], $result[0]['attrvalue3'], $result[0]['attrtype4'], $result[0]['attrvalue4'], $result[0]['attrtype5'], $result[0]['attrvalue5'], 
                                    $result[0]['attrtype6'], $result[0]['attrvalue6'])))
                                    $success = true;
            }

        }
    }

    if($success)
    {
        is_update_last_bought($id);
        is_insert_log($id);
        return true;
    }
    return false;
}

function autoDeletePromotions()
{
    global $database;
    
    $expire = strtotime("now - 1 hour UTC");

    $sth = $database->runQuerySqlite("DELETE FROM item_shop_items WHERE expire != 0 AND expire < ?");
    $sth->bindParam(1, $expire, PDO::PARAM_INT);
    $sth->execute();
    
    $sth = $database->runQuerySqlite("DELETE FROM item_shop_bonuses WHERE expire != 0 AND expire < ?");
    $sth->bindParam(1, $expire, PDO::PARAM_INT);
    $sth->execute();
    
    $sth = $database->runQuerySqlite("UPDATE item_shop_items SET discount = 0, discount_expire = 0 WHERE discount_expire != 0 AND discount_expire < ?");
    $sth->bindParam(1, $expire, PDO::PARAM_STR);
    $sth->execute();
}

function checkForPromotions($category)
{
    global $database;
    
    $stmt = $database->runQuerySqlite("SELECT id FROM item_shop_items WHERE expire > 0 AND category = ? ORDER BY id DESC LIMIT 1");
    $stmt->bindParam(1, $category, PDO::PARAM_INT);
    $stmt->execute();
    $result=$stmt->fetch(PDO::FETCH_ASSOC);
    
    if($result)
        return 1;
    else return 0;
}

function is_update_last_bought($id)
{
    global $database;
    
    $now = strtotime("now - 1 hour UTC");
    
    $stmt = $database->runQuerySqlite("UPDATE item_shop_items SET last_bought = ?, bought_count = bought_count + 1 WHERE id=?");
    $stmt->bindParam(1, $now, PDO::PARAM_INT);
    $stmt->bindParam(2, $id, PDO::PARAM_INT);
    $stmt->execute();
}

function is_insert_log($id)
{
    global $database;
    
    $now = strtotime("now - 1 hour UTC");
    
    $stmt = $database->runQuerySqlite("INSERT INTO log (account, item, date) VALUES (?, ?, ?)");
    $stmt->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
    $stmt->bindParam(2, $id, PDO::PARAM_INT);
    $stmt->bindParam(3, $now, PDO::PARAM_INT);
    $stmt->execute();
}

function is_get_bonuses_new()
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT '.$language_code.', id
        FROM items_bonuses');
    $sth->execute();
    $result = $sth->fetchAll();
    
    return $result;
}

function is_get_bonuses_new_name()
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT '.$language_code.', id
        FROM items_bonuses');
    $sth->execute();
    $result = $sth->fetchAll();
    
    $bonuses = array();
    
    foreach($result as $bonus)
        $bonuses[$bonus['id']] = $bonus[$language_code];
    
    return $bonuses;
}

function is_get_bonus_selection($id)
{
    global $database;
    global $language_code;
    
    $stmt = $database->runQuerySqlite('SELECT *
        FROM item_shop_bonuses WHERE id = ?');
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();
    $result=$stmt->fetch(PDO::FETCH_ASSOC);
    
    return $result;
}

function last_bought()
{
    global $database;
    global $language_code;
    
    $sth = $database->runQuerySqlite('SELECT id, vnum, pay_type, coins FROM item_shop_items WHERE last_bought != 0 ORDER BY last_bought DESC LIMIT 5');
    $sth->execute();
    $result = $sth->fetchAll();

    return $result;
}

function is_get_bonuses_values_used()
{
    global $database;
    global $language_code;
    
    $stmt = $database->runQuerySqlite('SELECT *
        FROM item_shop_bonuses');
    $stmt->execute();
    $result=$stmt->fetchAll();
    
    $bonus_value = array();
    
    for($i=1; $i<=96; $i++)
        $bonus_value[$i] = 0;
    
    foreach($result as $item)
        foreach($item as $key => $bonus)
            if($key[0]=='b' && $bonus>0)
                $bonus_value[intval(str_replace("bonus","", $key))] = $bonus;
            
    return $bonus_value;
}

function get_item_bonuses($item_id)
{
    global $database;

    try {
        $sth = $database->runQuerySqlite('SELECT * FROM item_shop_items WHERE id = ? LIMIT 1');
        $sth->bindParam(1, $item_id, PDO::PARAM_INT);
        $sth->execute();
        $item = $sth->fetch();

        if (!$item) {
            return array();
        }

        $bonuses = array();

        for ($i = 0; $i <= 6; $i++) {
            $type_key = 'attrtype' . $i;
            $value_key = 'attrvalue' . $i;

            if (isset($item[$type_key]) && isset($item[$value_key]) && $item[$type_key] != 0 && $item[$value_key] != 0) {
                $bonuses[] = array(
                    'category' => 'attribute',
                    'type' => $item[$type_key],
                    'value' => $item[$value_key],
                    'name' => get_item_bonus_name('attr', $item[$type_key]),
                    'formatted_value' => format_item_bonus_value('attr', $item[$type_key], $item[$value_key])
                );
            }
        }

        if (isset($item['applytype0'])) {
            for ($i = 0; $i <= 7; $i++) {
                $type_key = 'applytype' . $i;
                $value_key = 'applyvalue' . $i;

                if (isset($item[$type_key]) && isset($item[$value_key]) && $item[$type_key] != 0 && $item[$value_key] != 0) {
                    $bonuses[] = array(
                        'category' => 'apply',
                        'type' => $item[$type_key],
                        'value' => $item[$value_key],
                        'name' => get_item_bonus_name('apply', $item[$type_key]),
                        'formatted_value' => format_item_bonus_value('apply', $item[$type_key], $item[$value_key])
                    );
                }
            }
        }

        return $bonuses;
    } catch (Exception $e) {
        return array();
    }
}

function get_item_proto_bonuses($vnum)
{
    global $database;

    try {
        // Fetch apply types and values from item_proto
        // Assuming standard Metin2 structure with applytype0-2
        $stmt = $database->runQueryPlayer('SELECT applytype0, applyvalue0, applytype1, applyvalue1, applytype2, applyvalue2 FROM item_proto WHERE vnum = ?');
        $stmt->bindParam(1, $vnum, PDO::PARAM_INT);
        $stmt->execute();
        $proto = $stmt->fetch(PDO::FETCH_ASSOC);

        if (!$proto) {
            return array();
        }

        $bonuses = array();

        for ($i = 0; $i <= 2; $i++) {
            $type_key = 'applytype' . $i;
            $value_key = 'applyvalue' . $i;

            if (isset($proto[$type_key]) && isset($proto[$value_key]) && $proto[$type_key] != 0 && $proto[$value_key] != 0) {
                $bonuses[] = array(
                    'type' => $proto[$type_key],
                    'value' => $proto[$value_key],
                    'name' => get_item_bonus_name('apply', $proto[$type_key]),
                    'formatted_value' => format_item_bonus_value('apply', $proto[$type_key], $proto[$value_key])
                );
            }
        }

        return $bonuses;
    } catch (Exception $e) {
        return array();
    }
}

function get_item_bonus_name($category, $type)
{
    $attr_names = array(
        1 => 'STR', 2 => 'DEX', 3 => 'VIT', 4 => 'INT', 5 => 'HP Max', 6 => 'SP Max', 7 => 'Velocità Movimento'
    );

    $apply_names = array(
        1 => 'HP Max', 2 => 'SP Max', 3 => 'Costituzione', 4 => 'Intelligenza', 5 => 'Forza', 6 => 'Destrezza',
        7 => 'Velocità Attacco', 8 => 'Velocità Movimento', 9 => 'Velocità Lancio', 10 => 'Rigenerazione HP',
        11 => 'Rigenerazione SP', 12 => 'Assorbimento Veleno', 13 => 'Resistenza Stordimento', 14 => 'Resistenza Lentezza',
        15 => 'Colpo Critico', 16 => 'Colpo Penetrante', 17 => 'Danni contro Boss', 18 => 'Danni contro Mostri',
        19 => 'Danni contro Guerrieri', 20 => 'Danni contro Ninja', 21 => 'Danni contro Sura', 22 => 'Danni contro Sciamani',
        23 => 'Danni contro Mostri', 24 => 'Resistenza contro Guerrieri', 25 => 'Resistenza contro Ninja',
        26 => 'Resistenza contro Sura', 27 => 'Resistenza contro Sciamani', 28 => 'Resistenza Danni Freccia',
        29 => 'Resistenza Danni Spada', 30 => 'Resistenza Danni Spadone', 31 => 'Resistenza Danni Pugnale',
        32 => 'Resistenza Danni Campana', 33 => 'Resistenza Danni Ventaglio', 34 => 'Resistenza Fuoco',
        35 => 'Resistenza Elettricità', 36 => 'Resistenza Magia', 37 => 'Resistenza Vento', 38 => 'Rifletti Danno Diretto',
        39 => 'Rifletti Maledizione', 40 => 'Resistenza Veleno', 41 => 'EXP Bonus', 42 => 'Yang Bonus',
        43 => 'Drop Item Bonus', 44 => 'Danni Medi', 45 => 'Difesa Fisica', 46 => 'Difesa Magica', 
        48 => 'Difesa svenimento', 49 => 'Difesa rallentamento', 50 => 'Difesa caduta',
        53 => 'Valore d\'attacco', 54 => 'Difesa', 55 => 'Valore d\'attacco magico', 56 => 'Difesa magica', 58 => 'Max. resistenza',
        59 => 'Forte contro Guerrieri', 60 => 'Forte contro Ninja', 61 => 'Forte contro Sura', 62 => 'Forte contro Shamane',
        63 => 'Forte contro Mostri', 64 => 'Valore d\'attacco', 65 => 'Difesa', 66 => 'EXP', 67 => 'Possibilità drop oggetti', 68 => 'Possibilità drop Yang',
        69 => 'Max. HP', 70 => 'Max. MP', 71 => 'Danni abilità', 72 => 'Danni medi', 73 => 'Resistenza danni abilità', 74 => 'Resistenza danni medi',
        76 => 'iCafe EXP-Bonus', 77 => 'iCafe Drop Oggetti',
        78 => 'Resistenza Guerrieri', 79 => 'Resistenza Ninja', 80 => 'Resistenza Sura', 81 => 'Resistenza Shamani',
        82 => 'Energia', 84 => 'Bonus costume', 85 => 'Attacco magico', 86 => 'Attacco magico/corpo a corpo',
        87 => 'Resistenza Ghiaccio', 88 => 'Resistenza Terra', 89 => 'Resistenza Oscurità', 90 => 'Resistenza Critici', 91 => 'Resistenza Trafiggenti',
        92 => 'Forte contro Lican', 93 => 'Resistenza Lican', 94 => 'Resistenza Artigli', 95 => 'Attacco Sanguinante', 96 => 'Resistenza Sanguinante',
        99 => 'Forte contro Metin', 100 => 'Forte contro Boss', 101 => 'Resistenza Mezziuomini',
        118 => 'Resistenza Mostri', 119 => 'Danni medi (PVM)', 120 => 'Danni critici (PVM)'
    );

    if ($category == 'attr' && isset($attr_names[$type])) {
        return $attr_names[$type];
    } elseif ($category == 'apply' && isset($apply_names[$type])) {
        return $apply_names[$type];
    }

    return 'Bonus Sconosciuto';
}

function format_item_bonus_value($category, $type, $value)
{
    // IDs that are percentages
    $percentage_bonuses = array(
        7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47,
        59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 76, 77, 78, 79, 80, 81, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 99, 100, 101, 118, 119, 120
    );

    if (in_array($type, $percentage_bonuses)) {
        return '+' . $value . '%';
    }

    return '+' . $value;
}
?>