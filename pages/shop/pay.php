<?php
// Enable error logging
error_reporting(E_ALL);
ini_set('display_errors', 0);
ini_set('log_errors', 1);
ini_set('error_log', dirname(__FILE__).'/paypal_errors.log');

// Log function
function log_paypal($message) {
    $log_file = dirname(__FILE__).'/paypal_debug.log';
    $timestamp = date('[Y-m-d H:i:s]');
    file_put_contents($log_file, $timestamp . ' ' . $message . PHP_EOL, FILE_APPEND);
}

log_paypal('=== NEW IPN REQUEST ===');
log_paypal('POST Data: ' . print_r($_POST, true));

if (isset($_POST["txn_id"]) && isset($_POST["txn_type"])) {
    
    // Build the IPN verification request
    $req = 'cmd=_notify-validate';
    foreach ($_POST as $key => $value) {
        $value = urlencode(stripslashes($value));
        $value = preg_replace('/(.*[^%^0^D])(%0A)(.*)/i','${1}%0D%0A${3}',$value);
        $req .= "&$key=$value";
    }
    
    log_paypal('IPN Verification Request: ' . $req);
    
    // Collect payment data
    $data = array(
        'item_name'         => isset($_POST['item_name']) ? $_POST['item_name'] : '',
        'item_number'       => isset($_POST['item_number']) ? $_POST['item_number'] : '',
        'payment_status'    => isset($_POST['payment_status']) ? $_POST['payment_status'] : '',
        'payment_amount'    => isset($_POST['mc_gross']) ? $_POST['mc_gross'] : '',
        'payment_currency'  => isset($_POST['mc_currency']) ? $_POST['mc_currency'] : '',
        'txn_id'            => isset($_POST['txn_id']) ? $_POST['txn_id'] : '',
        'receiver_email'    => isset($_POST['receiver_email']) ? $_POST['receiver_email'] : '',
        'payer_email'       => isset($_POST['payer_email']) ? $_POST['payer_email'] : '',
        'custom'            => isset($_POST['custom']) ? $_POST['custom'] : ''
    );
    
    log_paypal('Payment Data: ' . print_r($data, true));
    
    // Initialize cURL
    $ch = curl_init();
    
    // IMPORTANT: Choose the correct URL
    // For SANDBOX (testing): https://ipnpb.sandbox.paypal.com/cgi-bin/webscr
    // For LIVE (production): https://ipnpb.paypal.com/cgi-bin/webscr
    
    $paypal_url = 'https://ipnpb.paypal.com/cgi-bin/webscr'; // LIVE
    // $paypal_url = 'https://ipnpb.sandbox.paypal.com/cgi-bin/webscr'; // SANDBOX
    
    log_paypal('PayPal URL: ' . $paypal_url);
    
    curl_setopt($ch, CURLOPT_URL, $paypal_url);
    curl_setopt($ch, CURLOPT_HTTP_VERSION, CURL_HTTP_VERSION_1_1);
    curl_setopt($ch, CURLOPT_POST, 1);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_POSTFIELDS, $req);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 1);
    curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 2);
    curl_setopt($ch, CURLOPT_FORBID_REUSE, 1);
    curl_setopt($ch, CURLOPT_HTTPHEADER, array('Connection: Close'));
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 30);
    curl_setopt($ch, CURLOPT_TIMEOUT, 60);
    
    // Execute cURL
    $curl_result = @curl_exec($ch);
    $curl_error = curl_error($ch);
    $curl_errno = curl_errno($ch);
    $curl_info = curl_getinfo($ch);
    
    curl_close($ch);
    
    log_paypal('cURL Result: ' . $curl_result);
    log_paypal('cURL Error: ' . $curl_error);
    log_paypal('cURL Errno: ' . $curl_errno);
    log_paypal('cURL Info: ' . print_r($curl_info, true));
    
    // Check if we got a response
    if ($curl_result === false) {
        log_paypal('ERROR: cURL failed - ' . $curl_error);
        http_response_code(500);
        exit;
    }
    
    // Check if PayPal verified the IPN
    if (stripos($curl_result, "VERIFIED") !== false) {
        
        log_paypal('IPN VERIFIED by PayPal');
        
        // Verify receiver email
        $receiver_email_match = (strtolower($data['receiver_email']) == strtolower($paypal_email));
        log_paypal('Receiver email match: ' . ($receiver_email_match ? 'YES' : 'NO'));
        log_paypal('Expected: ' . $paypal_email . ' | Received: ' . $data['receiver_email']);
        
        // Verify currency
        $currency_match = ($data['payment_currency'] == "EUR");
        log_paypal('Currency match: ' . ($currency_match ? 'YES' : 'NO'));
        log_paypal('Expected: EUR | Received: ' . $data['payment_currency']);
        
        if ($receiver_email_match && $currency_match) {
            
            // Check if transaction ID is valid (not already processed)
            $valid_txnid = check_txnid_paypal($data['txn_id']);
            log_paypal('Valid TXN ID: ' . ($valid_txnid ? 'YES' : 'NO (already processed)'));
            
            // Check if price matches
            $valid_price = check_price_paypal($data['payment_amount'], $data['item_number']);
            log_paypal('Valid Price: ' . ($valid_price ? 'YES' : 'NO'));
            
            if ($valid_txnid && $valid_price) {
                
                // Check payment status
                if ($data['payment_status'] == "Completed") {
                    
                    log_paypal('Payment COMPLETED - Processing...');
                    
                    // Update payments table
                    $update_result = updatePayments($data);
                    log_paypal('Update Payments Result: ' . ($update_result ? 'SUCCESS' : 'FAILED'));
                    
                    // Add coins to user account
                    $coins_result = get_coins_paypal($data['custom'], $data['item_number']);
                    log_paypal('Add Coins Result: ' . ($coins_result ? 'SUCCESS' : 'FAILED'));
                    log_paypal('User: ' . $data['custom'] . ' | Package: ' . $data['item_number']);
                    
                    if ($coins_result) {
                        log_paypal('=== PAYMENT SUCCESSFUL ===');
                        http_response_code(200);
                    } else {
                        log_paypal('ERROR: Failed to add coins to user');
                        http_response_code(500);
                    }
                    
                } else {
                    log_paypal('Payment status is NOT Completed: ' . $data['payment_status']);
                }
                
            } else {
                log_paypal('ERROR: Invalid TXN ID or Price');
            }
            
        } else {
            log_paypal('ERROR: Receiver email or currency mismatch');
        }
        
    } elseif (stripos($curl_result, "INVALID") !== false) {
        
        log_paypal('ERROR: IPN INVALID - PayPal rejected the verification');
        http_response_code(400);
        
    } else {
        
        log_paypal('ERROR: Unknown PayPal response: ' . $curl_result);
        http_response_code(500);
        
    }
    
} else {
    log_paypal('ERROR: Missing txn_id or txn_type in POST data');
    http_response_code(400);
}

log_paypal('=== END IPN REQUEST ===');
?>