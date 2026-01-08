<?php
/**
 * Test wp-config.php loading
 * Upload this and visit: https://leminaldx.ct.ws/test-wp-config.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);

echo "<h2>Testing wp-config.php</h2>";

// Test database connection first
$host = 'sql202.infinityfree.com';
$user = 'if0_40851674';
$pass = '67tVOPYs0SqAw';
$db = 'if0_40851674_leminaldx';

echo "<p>Testing database connection...</p>";
$conn = @mysqli_connect($host, $user, $pass, $db);
if ($conn) {
    echo "<p style='color: green;'>✓ Database connection: OK</p>";
    mysqli_close($conn);
} else {
    echo "<p style='color: red;'>✗ Database connection: FAILED - " . mysqli_connect_error() . "</p>";
    exit;
}

// Test loading wp-config.php
echo "<p>Testing wp-config.php loading...</p>";
try {
    // Simulate what wp-load.php does
    if (file_exists('wp-config.php')) {
        require_once 'wp-config.php';
        echo "<p style='color: green;'>✓ wp-config.php loaded successfully</p>";
        echo "<p><strong>DB_NAME:</strong> " . (defined('DB_NAME') ? DB_NAME : 'NOT DEFINED') . "</p>";
        echo "<p><strong>DB_USER:</strong> " . (defined('DB_USER') ? DB_USER : 'NOT DEFINED') . "</p>";
        echo "<p><strong>DB_HOST:</strong> " . (defined('DB_HOST') ? DB_HOST : 'NOT DEFINED') . "</p>";
        echo "<p><strong>WP_HOME:</strong> " . (defined('WP_HOME') ? WP_HOME : 'NOT DEFINED') . "</p>";
        echo "<p><strong>WP_SITEURL:</strong> " . (defined('WP_SITEURL') ? WP_SITEURL : 'NOT DEFINED') . "</p>";
    } else {
        echo "<p style='color: red;'>✗ wp-config.php file not found</p>";
    }
} catch (Exception $e) {
    echo "<p style='color: red;'>✗ Error loading wp-config.php: " . $e->getMessage() . "</p>";
} catch (Error $e) {
    echo "<p style='color: red;'>✗ Fatal error: " . $e->getMessage() . "</p>";
    echo "<p><strong>File:</strong> " . $e->getFile() . "</p>";
    echo "<p><strong>Line:</strong> " . $e->getLine() . "</p>";
}

// Test loading wp-load.php
echo "<p>Testing wp-load.php...</p>";
if (file_exists('wp-load.php')) {
    try {
        // Don't actually require it, just check if it exists and can be read
        $content = file_get_contents('wp-load.php');
        if ($content !== false) {
            echo "<p style='color: green;'>✓ wp-load.php exists and is readable</p>";
        } else {
            echo "<p style='color: red;'>✗ wp-load.php exists but cannot be read</p>";
        }
    } catch (Exception $e) {
        echo "<p style='color: red;'>✗ Error reading wp-load.php: " . $e->getMessage() . "</p>";
    }
} else {
    echo "<p style='color: red;'>✗ wp-load.php not found</p>";
}

// Check required WordPress files
echo "<p>Checking required WordPress files...</p>";
$required_files = ['index.php', 'wp-blog-header.php', 'wp-load.php', 'wp-settings.php', 'wp-admin', 'wp-includes'];
foreach ($required_files as $file) {
    if (file_exists($file)) {
        echo "<p style='color: green;'>✓ $file exists</p>";
    } else {
        echo "<p style='color: red;'>✗ $file MISSING</p>";
    }
}

