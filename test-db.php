<?php
$host = 'sql202.infinityfree.com';
$user = 'if0_40851674';
$pass = '67tVOPYs0SqAw';
$db = 'if0_40851674_leminaldx';

$conn = @mysqli_connect($host, $user, $pass, $db);
if ($conn) {
    echo "Database connection: SUCCESS\n";
    mysqli_close($conn);
} else {
    echo "Database connection: FAILED - " . mysqli_connect_error() . "\n";
}
