<?php
/**
 * Child theme functions
 */

// Enqueue parent theme styles
function child_enqueue_styles() {
    wp_enqueue_style('parent-style', get_template_directory_uri() . '/style.css');

    // Enqueue built CSS and JS (after npm run build)
    wp_enqueue_style('child-theme-style', get_stylesheet_directory_uri() . '/dist/css/leminaldx-child.bundle.css', array('parent-style'), '1.0.0');
    wp_enqueue_script('child-theme-script', get_stylesheet_directory_uri() . '/dist/js/leminaldx-child.bundle.js', array('jquery'), '1.0.0', true);
}
add_action('wp_enqueue_scripts', 'child_enqueue_styles');

// Fix: Ensure all attachment URLs are absolute (fixes Elementor image rendering)
add_filter('wp_get_attachment_url', function($url) {
    if (empty($url)) {
        return $url;
    }
    // If URL doesn't start with http/https, make it absolute
    if (strpos($url, 'http') !== 0) {
        // If it starts with /, prepend home URL
        if (strpos($url, '/') === 0) {
            return home_url($url);
        }
        // Otherwise, prepend home URL with /
        return home_url('/' . ltrim($url, '/'));
    }
    return $url;
}, 10, 1);
