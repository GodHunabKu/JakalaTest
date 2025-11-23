<?php
/**
 * Shop AJAX API Endpoints
 * Gestisce richieste AJAX per gift system
 */

session_start();
header('Content-Type: application/json');
header('Cache-Control: no-cache, must-revalidate');

require_once __DIR__ . '/../include/functions/config.php';
require_once __DIR__ . '/../include/classes/user.php';
require_once __DIR__ . '/../include/functions/basic.php';
require_once __DIR__ . '/../include/functions/csrf.php';
require_once __DIR__ . '/../include/functions/rate_limit.php';
require_once __DIR__ . '/../include/functions/security_log.php';

$database = new USER($host, $user, $password);

// Verifica login
if(!is_loggedin()) {
    echo json_encode(['success' => false, 'error' => 'Non sei loggato']);
    exit;
}

// CSRF Protection
$csrf_token = isset($_POST['csrf_token']) ? $_POST['csrf_token'] : (isset($_GET['csrf_token']) ? $_GET['csrf_token'] : '');
if (!csrf_validate_token($csrf_token)) {
    security_log('CSRF_DETECTED_API', ['action' => $_POST['action'] ?? 'unknown'], 3);
    http_response_code(403);
    echo json_encode(['success' => false, 'error' => 'Invalid security token']);
    exit;
}

// Rate Limiting per API (30 requests per minute)
if (rate_limit_check('api_call', 30, 60)) {
    security_log('API_RATE_LIMIT_EXCEEDED', [], 2);
    http_response_code(429);
    echo json_encode(['success' => false, 'error' => 'Too many requests. Please wait a moment.']);
    exit;
}
rate_limit_record('api_call');

$action = isset($_POST['action']) ? $_POST['action'] : '';

switch($action) {

    // Gift System - Invia regalo a un giocatore
    case 'send_gift':
        $item_id = isset($_POST['item_id']) ? intval($_POST['item_id']) : 0;
        $recipient_name = isset($_POST['recipient']) ? trim($_POST['recipient']) : '';
        $gift_message = isset($_POST['message']) ? htmlspecialchars(trim($_POST['message']), ENT_QUOTES, 'UTF-8') : '';

        if($item_id > 0 && !empty($recipient_name)) {
            // Verifica che il destinatario esista
            $sth = $database->runQueryAccount('SELECT id FROM account WHERE login = ?');
            $sth->bindParam(1, $recipient_name, PDO::PARAM_STR);
            $sth->execute();
            $recipient = $sth->fetch();

            if(!$recipient) {
                echo json_encode(['success' => false, 'error' => 'Giocatore non trovato']);
                exit;
            }

            // Ottieni item
            $item = is_item_select($item_id);
            if(!$item || count($item) == 0) {
                echo json_encode(['success' => false, 'error' => 'Item non trovato']);
                exit;
            }

            $item_data = $item[0];
            $price = $item_data['discount'] > 0 ?
                $item_data['coins'] - ($item_data['coins'] * $item_data['discount'] / 100) :
                $item_data['coins'];

            // Verifica coins
            if(is_coins(0) < $price) {
                echo json_encode(['success' => false, 'error' => 'MD insufficienti']);
                exit;
            }

            // Transazione atomica
            try {
                $database->runQuerySqlite('BEGIN TRANSACTION');

                // Sottrai coins
                is_pay_coins(0, $price);

                // Inserisci item nel database del destinatario
                $why = "Regalo da " . get_account_name() . ($gift_message ? ": " . substr($gift_message, 0, 50) : '');
                $sth = $database->runQueryPlayer('INSERT INTO item_award (pid, login, vnum, count, given_time, why, mall) VALUES (?, ?, ?, ?, NOW(), ?, 1)');
                $sth->execute([
                    0,
                    $recipient_name,
                    $item_data['vnum'],
                    isset($item_data['count']) ? $item_data['count'] : 1,
                    $why
                ]);

                $database->runQuerySqlite('COMMIT');

                security_log('GIFT_SENT', [
                    'item_id' => $item_id,
                    'recipient' => $recipient_name,
                    'price' => $price
                ], 1);

                echo json_encode(['success' => true, 'message' => 'Regalo inviato a ' . htmlspecialchars($recipient_name, ENT_QUOTES, 'UTF-8')]);
            } catch (Exception $e) {
                $database->runQuerySqlite('ROLLBACK');
                echo json_encode(['success' => false, 'error' => 'Errore durante l\'invio del regalo']);
            }
        } else {
            echo json_encode(['success' => false, 'error' => 'Dati mancanti']);
        }
        break;

    default:
        echo json_encode(['success' => false, 'error' => 'Azione non valida']);
}
?>
