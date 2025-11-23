<?php
// shop_utils.php - Funzioni di utilità generale e configurazione

function redirect($url) {
    if(!headers_sent()) {
        header('Location: '.$url);
        exit;
    } else {
        echo '<script type="text/javascript">';
        echo 'window.location.href="'.$url.'";';
        echo '</script>';
        echo '<noscript>';
        echo '<meta http-equiv="refresh" content="0;url='.$url.'" />';
        echo '</noscript>';
        exit;
    }
}

function redirect_shop($url)
{
    global $shop_url;

    if ($url=='coins' && !is_loggedin())
        redirect($shop_url.'login');
    if($url=='login' && is_loggedin())
        redirect($shop_url);
    
    if(($url=='categories' || $url=='add_items' || $url=='add_items_bonus' || $url=='settings' || $url=='paypal') && (!is_loggedin() || web_admin_level()<9))
        redirect($shop_url);
}

function logout_shop()
{
    global $shop_url;
    
    // Unset all session values
    $_SESSION = array();

    // Delete the session cookie
    if (ini_get("session.use_cookies")) {
        $params = session_get_cookie_params();
        setcookie(session_name(), '', time() - 42000,
            $params["path"], $params["domain"],
            $params["secure"], $params["httponly"]
        );
    }

    // Destroy the session
    session_destroy();
    
    redirect($shop_url.'login');
}

function web_admin_level()
{
    global $database;
    
    $sth = $database->runQueryAccount('SELECT web_admin
        FROM account
        WHERE id = ?');
    $sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    return isset($result[0]['web_admin']) ? $result[0]['web_admin'] : 0;
}

function check_item_column($name)
{
    global $database;
    
    $sth = $database->runQueryPlayer("DESCRIBE item");
    $sth->execute();
    $columns = $sth->fetchAll(PDO::FETCH_COLUMN);
    
    if(in_array($name, $columns))
        return true;
    else return false;
}

function get_settings_time($id)
{
    global $database;
    
    $stmt = $database->runQuerySqlite('SELECT *
        FROM settings WHERE id = ?');
    $stmt->bindParam(1, $id, PDO::PARAM_INT);
    $stmt->execute();
    $result=$stmt->fetch(PDO::FETCH_ASSOC);
    
    return $result['value'];
}

function update_settings($time, $time2, $absorption, $name)
{
    global $database;
    
    $stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=1");
    $stmt->bindParam(1, $time, PDO::PARAM_INT);
    $stmt->execute();
    
    $stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=2");
    $stmt->bindParam(1, $time2, PDO::PARAM_INT);
    $stmt->execute();
    
    $stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=3");
    $stmt->bindParam(1, $absorption, PDO::PARAM_INT);
    $stmt->execute();
    
    $stmt = $database->runQuerySqlite("UPDATE settings SET value = ? WHERE id=4");
    $stmt->bindParam(1, $name, PDO::PARAM_INT);
    $stmt->execute();
}
?>