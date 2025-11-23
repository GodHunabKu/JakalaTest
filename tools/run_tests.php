#!/usr/bin/env php
<?php
/**
 * ========================================
 * SHOP SECURITY & FUNCTIONALITY TEST
 * Test completo di TUTTE le funzionalità
 * ========================================
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "========================================\n";
echo "🔍 SHOP COMPLETE TEST SUITE\n";
echo "========================================\n\n";

$tests_passed = 0;
$tests_failed = 0;
$errors = [];

function test($name, $condition, $error_message = '') {
    global $tests_passed, $tests_failed, $errors;

    if ($condition) {
        echo "✅ PASS: $name\n";
        $tests_passed++;
    } else {
        echo "❌ FAIL: $name\n";
        $tests_failed++;
        if ($error_message) {
            $errors[] = "  → $error_message";
            echo "  → $error_message\n";
        }
    }
}

echo "=== FILE EXISTENCE TESTS ===\n";

// Security Files
test(
    "CSRF functions file exists",
    file_exists(__DIR__ . '/../include/functions/csrf.php')
);

test(
    "Rate Limit functions file exists",
    file_exists(__DIR__ . '/../include/functions/rate_limit.php')
);

test(
    "Security Log functions file exists",
    file_exists(__DIR__ . '/../include/functions/security_log.php')
);

// Gasato Files
test(
    "Ultra-Optimized CSS exists",
    file_exists(__DIR__ . '/../assets/css/shop-ultra-optimized.css')
);

test(
    "Ultra-Gasato JS exists",
    file_exists(__DIR__ . '/../assets/js/shop-ultra-gasato.js')
);

test(
    "Homepage Ultra-Gasata exists",
    file_exists(__DIR__ . '/../pages/shop/home_ultra_gasato.php')
);

// Documentation
test(
    "Security Setup Guide exists",
    file_exists(__DIR__ . '/../SECURITY_SETUP.md')
);

test(
    "Gasato README exists",
    file_exists(__DIR__ . '/../README_GASATO.md')
);

test(
    "SQL Migration file exists",
    file_exists(__DIR__ . '/../tools/security_tables.sql')
);

echo "\n=== PHP SYNTAX TESTS ===\n";

$files_to_check = [
    'include/functions/csrf.php',
    'include/functions/rate_limit.php',
    'include/functions/security_log.php',
    'include/functions/header.php',
    'pages/shop/login.php',
    'pages/shop/home_ultra_gasato.php',
    'api/shop_api.php',
    'index.php'
];

foreach ($files_to_check as $file) {
    $full_path = __DIR__ . '/../' . $file;
    $output = [];
    $return_var = 0;
    exec("php -l " . escapeshellarg($full_path) . " 2>&1", $output, $return_var);

    test(
        "Syntax check: $file",
        $return_var === 0,
        implode("\n", $output)
    );
}

echo "\n=== FUNCTION DEFINITION TESTS ===\n";

// Load files to test functions
require_once __DIR__ . '/../include/functions/csrf.php';
require_once __DIR__ . '/../include/functions/rate_limit.php';
require_once __DIR__ . '/../include/functions/security_log.php';

// CSRF Functions
test("Function 'csrf_generate_token' exists", function_exists('csrf_generate_token'));
test("Function 'csrf_validate_token' exists", function_exists('csrf_validate_token'));
test("Function 'csrf_token_field' exists", function_exists('csrf_token_field'));
test("Function 'csrf_validate_or_die' exists", function_exists('csrf_validate_or_die'));

// Rate Limit Functions
test("Function 'rate_limit_check' exists", function_exists('rate_limit_check'));
test("Function 'rate_limit_record' exists", function_exists('rate_limit_record'));
test("Function 'rate_limit_reset' exists", function_exists('rate_limit_reset'));
test("Function 'rate_limit_get_remaining' exists", function_exists('rate_limit_get_remaining'));

// Security Log Functions
test("Function 'security_log' exists", function_exists('security_log'));
test("Function 'admin_audit_log' exists", function_exists('admin_audit_log'));

echo "\n=== CSRF IMPLEMENTATION TESTS ===\n";

$files_with_csrf = [
    'pages/shop/login.php' => 'csrf_token_field',
    'index.php' => 'csrf_token_field',
    'pages/shop/item.php' => 'csrf_token_field',
    'pages/shop/coins.php' => 'csrf_token_field',
    'include/functions/header.php' => 'csrf_validate_or_die'
];

foreach ($files_with_csrf as $file => $function) {
    $content = file_get_contents(__DIR__ . '/../' . $file);
    test(
        "CSRF in $file",
        strpos($content, $function) !== false,
        "$function not found in $file"
    );
}

echo "\n=== RATE LIMITING IMPLEMENTATION TESTS ===\n";

$files_with_rate_limit = [
    'pages/shop/login.php' => ['rate_limit_check', 'rate_limit_record'],
    'api/shop_api.php' => ['rate_limit_check', 'rate_limit_record']
];

foreach ($files_with_rate_limit as $file => $functions) {
    $content = file_get_contents(__DIR__ . '/../' . $file);
    foreach ($functions as $func) {
        test(
            "Rate limit ($func) in $file",
            strpos($content, $func) !== false
        );
    }
}

echo "\n=== SECURITY LOGGING TESTS ===\n";

$files_with_logging = [
    'pages/shop/login.php' => ['security_log'],
    'api/shop_api.php' => ['security_log'],
    'include/functions/header.php' => ['security_log', 'admin_audit_log']
];

foreach ($files_with_logging as $file => $functions) {
    $content = file_get_contents(__DIR__ . '/../' . $file);
    foreach ($functions as $func) {
        test(
            "Logging ($func) in $file",
            strpos($content, $func) !== false
        );
    }
}

echo "\n=== CSS/JS INTEGRATION TESTS ===\n";

$index_content = file_get_contents(__DIR__ . '/../index.php');

test(
    "Ultra-Optimized CSS included in index.php",
    strpos($index_content, 'shop-ultra-optimized.css') !== false
);

test(
    "Ultra-Gasato JS included in index.php",
    strpos($index_content, 'shop-ultra-gasato.js') !== false
);

test(
    "Homepage Ultra-Gasata loaded in index.php",
    strpos($index_content, 'home_ultra_gasato.php') !== false
);

echo "\n=== CSS FILE CONTENT TESTS ===\n";

$css_content = file_get_contents(__DIR__ . '/../assets/css/shop-ultra-optimized.css');

test("CSS has animations", strpos($css_content, '@keyframes') !== false);
test("CSS has variables", strpos($css_content, ':root') !== false);
test("CSS has utility classes", strpos($css_content, '.gasato-btn') !== false);

echo "\n=== JS FILE CONTENT TESTS ===\n";

$js_content = file_get_contents(__DIR__ . '/../assets/js/shop-ultra-gasato.js');

test("JS has Toast system", strpos($js_content, 'const Toast') !== false);
test("JS has Popup system", strpos($js_content, 'MotivationalPopup') !== false);
test("JS has Particles system", strpos($js_content, 'const Particles') !== false);
test("JS has Countdown", strpos($js_content, 'const Countdown') !== false);
test("JS exposes global API", strpos($js_content, 'window.ShopGasato') !== false);

echo "\n=== HOMEPAGE CONTENT TESTS ===\n";

$home_content = file_get_contents(__DIR__ . '/../pages/shop/home_ultra_gasato.php');

test("Homepage has Hero section", strpos($home_content, 'one-hero-bento') !== false);
test("Homepage has Stats bar", strpos($home_content, 'stats-bar') !== false);
test("Homepage has Deal of Day", strpos($home_content, 'deal-of-day') !== false);
test("Homepage has Categories", strpos($home_content, 'shop-categories') !== false);
test("Homepage has Countdown", strpos($home_content, 'data-countdown') !== false);
test("Homepage has Badges", strpos($home_content, 'badge-gasato') !== false);

echo "\n========================================\n";
echo "📊 TEST RESULTS\n";
echo "========================================\n";
echo "✅ Passed: $tests_passed\n";
echo "❌ Failed: $tests_failed\n";
echo "📈 Success Rate: " . round(($tests_passed / ($tests_passed + $tests_failed)) * 100, 2) . "%\n";

if ($tests_failed > 0) {
    echo "\n⚠️  ERRORS FOUND:\n";
    foreach ($errors as $error) {
        echo "$error\n";
    }
    echo "\n";
    exit(1);
} else {
    echo "\n🎉 ALL TESTS PASSED! Shop is ready to rock! 🚀\n\n";
    exit(0);
}
?>
