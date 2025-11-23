<?php
/**
 * History Log Reader - Legge lo storico acquisti da file di log
 */

// Definisci la root dello shop
define('SHOP_ROOT', dirname(dirname(__DIR__)));

session_start();
header('Content-Type: application/json');
header('Cache-Control: no-cache, must-revalidate');

require_once SHOP_ROOT . '/config.php';
require_once SHOP_ROOT . '/include/functions/language.php';
require_once SHOP_ROOT . '/include/classes/user.php';
require_once SHOP_ROOT . '/include/functions/basic.php';

// Inizializza database
$database = new USER($host, $user, $password);

// Verifica login
if(!is_loggedin()) {
    echo json_encode(['success' => false, 'error' => 'Non sei loggato']);
    exit;
}

$account_login = get_account_name();
$log_file = __DIR__ . '/purchases_' . $account_login . '.txt';

$history = array();

// Leggi il file di log se esiste
if (file_exists($log_file)) {
    $lines = file($log_file, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
    
    foreach ($lines as $line) {
        $data = json_decode($line, true);
        if ($data && is_array($data)) {
            $history[] = $data;
        }
    }
}

// Ordina per data decrescente
usort($history, function($a, $b) {
    return strcmp($b['given_time'], $a['given_time']);
});

echo json_encode(['success' => true, 'history' => $history]);
?>
