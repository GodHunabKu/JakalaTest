<?php
// shop_account.php - Gestione Account, Login e Monete

function login($uname,$upass,$shop=0)
{
    global $database, $lang_shop, $shop_url;
        
    $stmt = $database->runQueryAccount("SELECT id, login, password, status FROM account WHERE login=:uname AND password=:upass LIMIT 1");
    $stmt->execute(array(':uname'=>$uname, ':upass'=>strtoupper("*".sha1(sha1($upass, true)))));
    
    $userRow=$stmt->fetch(PDO::FETCH_ASSOC);
    if($stmt->rowCount() > 0)
    {
        if($userRow['status']=='OK')
        {
            // Security: Regenerate session ID to prevent fixation
            session_regenerate_id(true);
            
            $_SESSION['id'] = $userRow['id'];
            $_SESSION['fingerprint'] = md5($_SERVER['HTTP_USER_AGENT'] . 'x' . $_SERVER['REMOTE_ADDR']);
            // Inizializza buy_key per sicurezza acquisti
            $_SESSION['buy_key'] = mt_rand(1, 10000);
            redirect($shop_url);
            return true;
        } else {
            print '<div class="alert alert-dismissible alert-warning">
                    <button type="button" class="close" data-dismiss="alert">×</button>
                    '.$lang_shop['blocked_account'].'
                </div>';
            return false;
        }
    }
    else
    {
        return false;
    }
}

function is_loggedin()
{
    if(isset($_SESSION['id']))
        return true;
    return false;
}

function fingerprint()
{
    if(is_loggedin())
        if ($_SESSION['fingerprint'] != md5($_SERVER['HTTP_USER_AGENT'] . 'x' . $_SERVER['REMOTE_ADDR']))
            session_destroy();
}

function get_account_id()
{
    return isset($_SESSION['id']) ? intval($_SESSION['id']) : 0;
}

function get_account_name()
{
    global $database;

    $sth = $database->runQueryAccount('SELECT login
        FROM account
        WHERE id = ? LIMIT 1');
    $sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();

    return isset($result[0]['login']) ? $result[0]['login'] : 'Unknown';
}

function is_coins($type=0)
{
    global $database;
    
    $sth = $database->runQueryAccount('SELECT coins, jcoins
        FROM account
        WHERE id = ?');
    $sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(!$type)
        return isset($result[0]['coins']) ? $result[0]['coins'] : 0;
    else
        return isset($result[0]['jcoins']) ? $result[0]['jcoins'] : 0;
}

function is_pay_coins($type, $coins)
{
    global $database;
    
    if(!$type)
        $stmt = $database->runQueryAccount("UPDATE account set coins = coins - ? WHERE id = ?");
    else
        $stmt = $database->runQueryAccount("UPDATE account set jcoins = jcoins - ? WHERE id = ?");
        
    $stmt->bindParam(1, $coins, PDO::PARAM_INT);
    $stmt->bindParam(2, $_SESSION['id'], PDO::PARAM_INT);
    $stmt->execute();
    
    if(!$type)
        get_js_back(intval($coins/2));
}

// FIX RACE CONDITION: Tentativo di pagamento atomico
function attempt_pay_coins($type, $amount) {
    global $database;
    $id = $_SESSION['id'];
    
    if(!$type) {
        // Coins (MD)
        $stmt = $database->runQueryAccount("UPDATE account SET coins = coins - ? WHERE id = ? AND coins >= ?");
    } else {
        // JCoins (Gettoni)
        $stmt = $database->runQueryAccount("UPDATE account SET jcoins = jcoins - ? WHERE id = ? AND jcoins >= ?");
    }

    $stmt->bindParam(1, $amount, PDO::PARAM_INT);
    $stmt->bindParam(2, $id, PDO::PARAM_INT);
    $stmt->bindParam(3, $amount, PDO::PARAM_INT);
    $stmt->execute();
    
    if ($stmt->rowCount() > 0) {
        // Pagamento riuscito
        if(!$type) {
            // Diamo cashback solo se paga in MD
            get_js_back(intval($amount/2));
        }
        return true;
    }
    
    return false;
}

// Funzione per rimborsare in caso di errore nella consegna item
function refund_coins($type, $amount) {
    global $database;
    $id = $_SESSION['id'];
    
    if(!$type) {
        $stmt = $database->runQueryAccount("UPDATE account SET coins = coins + ? WHERE id = ?");
    } else {
        $stmt = $database->runQueryAccount("UPDATE account SET jcoins = jcoins + ? WHERE id = ?");
    }

    $stmt->bindParam(1, $amount, PDO::PARAM_INT);
    $stmt->bindParam(2, $id, PDO::PARAM_INT);
    $stmt->execute();
    
    // Se era un pagamento in MD, rimuoviamo anche il cashback dato per errore
    if(!$type) {
        $jcoins_back = intval($amount/2);
        $stmt2 = $database->runQueryAccount("UPDATE account SET jcoins = jcoins - ? WHERE id = ? AND jcoins >= ?");
        $stmt2->bindParam(1, $jcoins_back, PDO::PARAM_INT);
        $stmt2->bindParam(2, $id, PDO::PARAM_INT);
        $stmt2->bindParam(3, $jcoins_back, PDO::PARAM_INT);
        $stmt2->execute();
    }
}

function get_js_back($jcoins)
{
    global $database;
    
    $stmt = $database->runQueryAccount("UPDATE account set jcoins = jcoins + ? WHERE id = ?");
    
    $stmt->bindParam(1, $jcoins, PDO::PARAM_INT);
    $stmt->bindParam(2, $_SESSION['id'], PDO::PARAM_INT);
    $stmt->execute();
}

function char_big_lvl()
{
    global $database;
    
    $sth = $database->runQueryPlayer('SELECT name, job, level, exp
        FROM player
        WHERE account_id = ? ORDER BY level DESC, exp DESC LIMIT 1');
    $sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
    $sth->execute();
    $result = $sth->fetchAll();
    
    if(isset($result[0]['job']))
        print $result[0]['job'];
    else print 0;
}
?>