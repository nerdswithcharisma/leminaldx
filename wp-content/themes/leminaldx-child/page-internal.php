<?php
/**
 * Template Name: Internal Pages
 * Description: Template for internal/standard content pages.
 */
get_header();

while (have_posts()) :
    the_post();
    $thumb_url = get_the_post_thumbnail_url(get_the_ID(), 'full');
    $underlay_style = $thumb_url
        ? 'background-image: url(' . esc_url($thumb_url) . ');'
        : 'background-color: #233b9d;';
    ?>
    <div class="leminal-internal-underlay" style="<?php echo $underlay_style; ?>"></div>
    <main id="leminal-internal-content" class="site-main site-main--internal">
        <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
            <div class="entry-content">
                <?php the_content(); ?>
            </div>
        </article>
    </main>
    <?php
endwhile;

get_footer();
