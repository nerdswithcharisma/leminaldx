<?php
/**
 * Test database connection for InfinityFree
 * Upload this to your server and visit: https://leminaldx.ct.ws/test-db-connection.php
 */

// Try the current credentials
$host = 'sql202.infinityfree.com';
$user = 'if0_40851674';
$pass = '67tVOPYs0SqAw';
$db = 'if0_40851674_leminaldx';

echo "<h2>Testing Database Connection</h2>";
echo "<p><strong>Host:</strong> $host</p>";
echo "<p><strong>User:</strong> $user</p>";
echo "<p><strong>Database:</strong> $db</p>";

$conn = @mysqli_connect($host, $user, $pass, $db);

if ($conn) {
    echo "<p style='color: green;'><strong>✓ Database connection: SUCCESS</strong></p>";

    // Check if WordPress tables exist
    $tables = mysqli_query($conn, "SHOW TABLES LIKE 'wp_%'");
    $table_count = mysqli_num_rows($tables);
    echo "<p><strong>WordPress tables found:</strong> $table_count</p>";

    if ($table_count == 0) {
        echo "<p style='color: orange;'><strong>⚠ WordPress is not installed. You need to run the installer.</strong></p>";
        echo "<p><a href='/wp-admin/install.php'>Run WordPress Installer</a></p>";
    }

    mysqli_close($conn);
} else {
    echo "<p style='color: red;'><strong>✗ Database connection: FAILED</strong></p>";
    echo "<p><strong>Error:</strong> " . mysqli_connect_error() . "</p>";
    echo "<p><strong>Error Code:</strong> " . mysqli_connect_errno() . "</p>";
    echo "<p>Please check your database credentials in the InfinityFree control panel.</p>";
}

