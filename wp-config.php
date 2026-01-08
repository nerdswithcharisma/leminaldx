<?php
/**
 * WordPress Configuration
 * Project: leminaldx
 */

// Database settings
if (strpos($_SERVER['HTTP_HOST'], 'localhost') !== false || strpos($_SERVER['HTTP_HOST'], '127.0.0.1') !== false) {
    // Local Docker settings
    define('DB_NAME', 'leminaldx_wordpress');
    define('DB_USER', 'wordpress');
    define('DB_PASSWORD', 'wordpress');
    define('DB_HOST', 'db:3306');
} else {
    // InfinityFree settings (Production)
    define('DB_NAME', 'if0_40851674_leminaldx');
    define('DB_USER', 'if0_40851674');
    define('DB_PASSWORD', '67tVOPYs0SqAw');
    define('DB_HOST', 'sql202.infinityfree.com');
}
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// WordPress Database Table prefix
$table_prefix = 'wp_';

// Debugging
if (strpos($_SERVER['HTTP_HOST'], 'localhost') !== false || strpos($_SERVER['HTTP_HOST'], '127.0.0.1') !== false) {
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', false);
} else {
    // Production - enable error display temporarily to debug 500 errors
    define('WP_DEBUG', true);
    define('WP_DEBUG_LOG', true);
    define('WP_DEBUG_DISPLAY', true);
    @ini_set('display_errors', 1);
    error_reporting(E_ALL);
}

// Memory limit
define('WP_MEMORY_LIMIT', '256M');

// Security keys (generate at https://api.wordpress.org/secret-key/1.1/salt/)
define('AUTH_KEY',         'put your unique phrase here');
define('SECURE_AUTH_KEY',  'put your unique phrase here');
define('LOGGED_IN_KEY',    'put your unique phrase here');
define('NONCE_KEY',        'put your unique phrase here');
define('AUTH_SALT',        'put your unique phrase here');
define('SECURE_AUTH_SALT', 'put your unique phrase here');
define('LOGGED_IN_SALT',   'put your unique phrase here');
define('NONCE_SALT',       'put your unique phrase here');

// WordPress URLs (for production)
// Only set if not already defined and we're not on localhost
if (!defined('WP_HOME') && !defined('WP_SITEURL')) {
    if (strpos($_SERVER['HTTP_HOST'], 'localhost') === false && strpos($_SERVER['HTTP_HOST'], '127.0.0.1') === false) {
        // Production URL
        define('WP_HOME', 'https://leminaldx.ct.ws');
        define('WP_SITEURL', 'https://leminaldx.ct.ws');
    }
}

// Absolute path to WordPress directory
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
