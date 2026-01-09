<?php
/**
 * Error Handler - Shows actual PHP errors
 * Upload this to your server and visit: https://leminaldx.ct.ws/error-handler.php
 */

error_reporting(E_ALL);
ini_set('display_errors', 1);
ini_set('log_errors', 1);

echo "<h2>WordPress Error Diagnostics</h2>";

// Test wp-config.php loading
echo "<h3>1. Testing wp-config.php</h3>";
if (file_exists('wp-config.php')) {
    echo "<p style='color: green;'>✓ wp-config.php exists</p>";
    try {
        require_once 'wp-config.php';
        echo "<p style='color: green;'>✓ wp-config.php loaded successfully</p>";
    } catch (Throwable $e) {
        echo "<p style='color: red;'>✗ Error loading wp-config.php: " . $e->getMessage() . "</p>";
        echo "<p><strong>File:</strong> " . $e->getFile() . "</p>";
        echo "<p><strong>Line:</strong> " . $e->getLine() . "</p>";
    }
} else {
    echo "<p style='color: red;'>✗ wp-config.php not found</p>";
}

// Test database connection
echo "<h3>2. Testing Database Connection</h3>";
if (defined('DB_HOST') && defined('DB_USER') && defined('DB_NAME')) {
    $conn = @mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);
    if ($conn) {
        echo "<p style='color: green;'>✓ Database connection: SUCCESS</p>";

        // Check active plugins
        $result = mysqli_query($conn, "SELECT option_value FROM wp_options WHERE option_name = 'active_plugins'");
        if ($result && $row = mysqli_fetch_assoc($result)) {
            $active_plugins = unserialize($row['option_value']);
            if (is_array($active_plugins) && !empty($active_plugins)) {
                echo "<p><strong>Active plugins in database:</strong> " . count($active_plugins) . "</p>";
                echo "<ul>";
                foreach ($active_plugins as $plugin) {
                    $plugin_path = 'wp-content/plugins/' . $plugin;
                    $exists = file_exists($plugin_path);
                    $status = $exists ? "✓" : "✗ MISSING";
                    $color = $exists ? "green" : "red";
                    echo "<li style='color: $color;'>$status $plugin</li>";
                }
                echo "</ul>";
            }
        }

        mysqli_close($conn);
    } else {
        echo "<p style='color: red;'>✗ Database connection: FAILED</p>";
        echo "<p><strong>Error:</strong> " . mysqli_connect_error() . "</p>";
    }
} else {
    echo "<p style='color: orange;'>⚠ Database constants not defined</p>";
}

// Test WordPress loading
echo "<h3>3. Testing WordPress Load</h3>";
if (file_exists('wp-load.php')) {
    echo "<p style='color: green;'>✓ wp-load.php exists</p>";
    try {
        // Capture any output/errors
        ob_start();
        $error = false;
        set_error_handler(function($errno, $errstr, $errfile, $errline) use (&$error) {
            $error = "$errstr in $errfile on line $errline";
            return true;
        });

        require_once 'wp-load.php';

        restore_error_handler();
        $output = ob_get_clean();

        if ($error) {
            echo "<p style='color: red;'>✗ Error loading WordPress: $error</p>";
        } else {
            echo "<p style='color: green;'>✓ WordPress loaded successfully</p>";
        }
    } catch (Throwable $e) {
        echo "<p style='color: red;'>✗ Fatal error: " . $e->getMessage() . "</p>";
        echo "<p><strong>File:</strong> " . $e->getFile() . "</p>";
        echo "<p><strong>Line:</strong> " . $e->getLine() . "</p>";
        echo "<pre>" . $e->getTraceAsString() . "</pre>";
    }
} else {
    echo "<p style='color: red;'>✗ wp-load.php not found</p>";
}

// Check debug log
echo "<h3>4. Recent Debug Log Entries</h3>";
$debug_log = 'wp-content/debug.log';
if (file_exists($debug_log)) {
    $lines = file($debug_log);
    $recent = array_slice($lines, -20); // Last 20 lines
    echo "<pre style='background: #f5f5f5; padding: 10px; overflow-x: auto;'>";
    echo htmlspecialchars(implode('', $recent));
    echo "</pre>";
} else {
    echo "<p style='color: orange;'>⚠ Debug log not found at: $debug_log</p>";
}

