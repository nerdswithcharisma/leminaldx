<?php
/**
 * Fix WordPress URLs in database
 * Run this once via browser: http://localhost:8080/fix-urls.php
 * Then delete this file for security
 */

// Load WordPress
require_once(__DIR__ . '/wp-load.php');

// Only allow if WP_DEBUG is enabled (safety check)
if (!defined('WP_DEBUG') || !WP_DEBUG) {
    die('This script can only run when WP_DEBUG is enabled.');
}

global $wpdb;

$old_url = 'https://websitedemos.net/tech-startup-02';
$new_url = 'http://localhost:8080';

echo "<h1>Fixing WordPress URLs</h1>";
echo "<pre>";

// Tables to update
$tables = [
    $wpdb->posts => ['post_content', 'post_excerpt', 'guid'],
    $wpdb->postmeta => ['meta_value'],
    $wpdb->options => ['option_value'],
    $wpdb->comments => ['comment_content'],
    $wpdb->commentmeta => ['meta_value'],
];

$total_replacements = 0;

foreach ($tables as $table => $columns) {
    foreach ($columns as $column) {
        // Replace URLs with quotes: "https://websitedemos.net/..." -> http://localhost:8080/...
        $quoted_old = '"' . $old_url;
        $quoted_new = $new_url;
        
        $sql = $wpdb->prepare(
            "UPDATE {$table} SET {$column} = REPLACE({$column}, %s, %s) WHERE {$column} LIKE %s",
            $quoted_old,
            $quoted_new,
            '%' . $wpdb->esc_like($quoted_old) . '%'
        );
        
        $result = $wpdb->query($sql);
        if ($result !== false) {
            $total_replacements += $result;
            echo "Updated {$table}.{$column}: {$result} rows\n";
        }
        
        // Replace URLs without quotes
        $sql2 = $wpdb->prepare(
            "UPDATE {$table} SET {$column} = REPLACE({$column}, %s, %s) WHERE {$column} LIKE %s",
            $old_url,
            $new_url,
            '%' . $wpdb->esc_like($old_url) . '%'
        );
        
        $result2 = $wpdb->query($sql2);
        if ($result2 !== false) {
            $total_replacements += $result2;
            echo "Updated {$table}.{$column} (no quotes): {$result2} rows\n";
        }
        
        // Replace URLs with trailing quotes: ...url.png" -> ...url.png
        $sql3 = $wpdb->prepare(
            "UPDATE {$table} SET {$column} = REPLACE({$column}, %s, %s) WHERE {$column} LIKE %s",
            $old_url . '"',
            $new_url,
            '%' . $wpdb->esc_like($old_url . '"') . '%'
        );
        
        $result3 = $wpdb->query($sql3);
        if ($result3 !== false) {
            $total_replacements += $result3;
            echo "Updated {$table}.{$column} (trailing quote): {$result3} rows\n";
        }
    }
}

// Update siteurl and home options
update_option('siteurl', $new_url);
update_option('home', $new_url);

echo "\n";
echo "Total replacements: {$total_replacements}\n";
echo "Site URL updated to: {$new_url}\n";
echo "Home URL updated to: {$new_url}\n";
echo "\n";
echo "✓ Done! Please delete this file (fix-urls.php) for security.\n";
echo "</pre>";
