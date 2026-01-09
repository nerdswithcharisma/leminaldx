<?php
/**
 * Disable all plugins in database (run this if plugins are missing)
 * Upload to server and visit: https://leminaldx.ct.ws/disable-plugins.php
 * DELETE THIS FILE after use for security!
 */

require_once 'wp-config.php';

$conn = mysqli_connect(DB_HOST, DB_USER, DB_PASSWORD, DB_NAME);

if (!$conn) {
    die("Database connection failed: " . mysqli_connect_error());
}

// Disable all plugins
$result = mysqli_query($conn, "UPDATE wp_options SET option_value = '' WHERE option_name = 'active_plugins'");

if ($result) {
    echo "<h2 style='color: green;'>✓ All plugins disabled in database</h2>";
    echo "<p>You can now access WordPress. Install plugins via WordPress admin.</p>";
    echo "<p><strong>IMPORTANT: Delete this file (disable-plugins.php) for security!</strong></p>";
} else {
    echo "<h2 style='color: red;'>✗ Failed to disable plugins</h2>";
    echo "<p>Error: " . mysqli_error($conn) . "</p>";
}

mysqli_close($conn);

