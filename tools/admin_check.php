<?php
// Admin Debug Tool
// Place this in the root or tools folder and access via browser
// e.g. yoursite.com/tools/admin_check.php

// Adjust path to include header.php depending on where this file is placed
// If in tools/ folder:
require_once '../include/functions/header.php';

// If in root:
// require_once 'include/functions/header.php';

echo "<h1>Admin Permission Debugger</h1>";

if(!is_loggedin()) {
    echo "<p style='color:red'>You are NOT logged in.</p>";
    echo "<p>Please log in to the shop first, then refresh this page.</p>";
    exit;
}

echo "<p style='color:green'>You are logged in.</p>";
echo "<ul>";
echo "<li><strong>User ID:</strong> " . $_SESSION['id'] . "</li>";
echo "<li><strong>Username:</strong> " . $_SESSION['username'] . "</li>"; // Assuming username is in session
echo "</ul>";

// Check DB directly
global $database;
$sth = $database->runQueryAccount('SELECT id, login, web_admin FROM account WHERE id = ?');
$sth->bindParam(1, $_SESSION['id'], PDO::PARAM_INT);
$sth->execute();
$result = $sth->fetchAll();

if(count($result) > 0) {
    $user = $result[0];
    echo "<h2>Database Record</h2>";
    echo "<pre>";
    print_r($user);
    echo "</pre>";
    
    $db_level = isset($user['web_admin']) ? $user['web_admin'] : 'NULL';
    echo "<p><strong>web_admin column value:</strong> " . $db_level . "</p>";
    
    if($db_level >= 9) {
        echo "<p style='color:green; font-weight:bold;'>Database says you ARE an admin (Level >= 9).</p>";
    } else {
        echo "<p style='color:red; font-weight:bold;'>Database says you are NOT an admin (Level < 9).</p>";
        echo "<p>Please update your account in the 'account' table, set 'web_admin' to 9.</p>";
    }
} else {
    echo "<p style='color:red'>Could not find user in database!</p>";
}

// Check function
echo "<h2>Function Check</h2>";
$func_level = web_admin_level();
echo "<p><strong>web_admin_level() returns:</strong> " . $func_level . "</p>";

if($func_level >= 9) {
    echo "<p style='color:green'>The system recognizes you as Admin.</p>";
} else {
    echo "<p style='color:red'>The system DOES NOT recognize you as Admin.</p>";
}
?>