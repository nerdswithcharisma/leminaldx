<?php
/**
 * Child theme functions
 */

// Enqueue parent theme styles
function child_enqueue_styles() {
    wp_enqueue_style('parent-style', get_template_directory_uri() . '/style.css');

    $is_local = strpos($_SERVER['HTTP_HOST'] ?? '', 'localhost') !== false
        || strpos($_SERVER['HTTP_HOST'] ?? '', '127.0.0.1') !== false;
    $is_dev = $is_local && defined('WP_DEBUG') && WP_DEBUG && ! is_admin();
    $base = $is_dev
        ? 'http://localhost:3000'
        : get_stylesheet_directory_uri() . '/dist';

    wp_enqueue_style('child-theme-style', $base . '/css/leminaldx-child.bundle.css', array('parent-style'), '1.0.0');
    wp_enqueue_script('child-theme-script', $base . '/js/leminaldx-child.bundle.js', array('jquery'), '1.0.0', true);
}
add_action('wp_enqueue_scripts', 'child_enqueue_styles');

// Add Google Analytics
function leminaldx_add_google_analytics() {
    ?>
    <!-- Google tag (gtag.js) -->
    <script async src="https://www.googletagmanager.com/gtag/js?id=G-E7W7Y08WMM"></script>
    <script>
        window.dataLayer = window.dataLayer || [];
        function gtag(){dataLayer.push(arguments);}
        gtag('js', new Date());
        gtag('config', 'G-E7W7Y08WMM');
    </script>
    <?php
}
add_action('wp_head', 'leminaldx_add_google_analytics');
