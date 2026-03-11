<?php
/**
 * Template Name: Internal Pages
 * Description: Template for internal/standard content pages.
 */
get_header();
?>
<main id="main" class="site-main site-main--internal">
    <?php
    while (have_posts()) :
        the_post();
        ?>
        <article id="post-<?php the_ID(); ?>" <?php post_class(); ?>>
            <div class="entry-content">
                <?php the_content(); ?>
            </div>
        </article>
        <?php
    endwhile;
    ?>
</main>
<?php
get_footer();
