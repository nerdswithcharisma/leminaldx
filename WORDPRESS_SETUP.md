# WordPress Initial Setup

After setting up the build template, you need to install WordPress in your new project.

## Option 1: Fresh WordPress Install (Recommended for New Projects)

The Docker WordPress image will automatically download WordPress on first run, but you need:

1. **Create wp-content directory:**

   ```bash
   mkdir -p wp-content/themes wp-content/plugins wp-content/uploads
   ```

2. **Create wp-config.php:**

   ```bash
   # Copy from WordPress or create minimal config
   ```

3. **Start Docker:**

   ```bash
   docker-compose up -d
   ```

4. **Visit http://localhost:8080** - WordPress installer will run automatically

## Option 2: Copy from Existing Project

If you have an existing WordPress installation:

1. **Copy WordPress core files:**

   ```bash
   # From your existing WordPress project
   cp -r wp-admin wp-includes wp-*.php index.php /path/to/new-project/
   ```

2. **Copy wp-config.php and update:**

   ```bash
   cp wp-config.php /path/to/new-project/
   # Edit wp-config.php and update database name to match docker-compose.yml
   ```

3. **Copy wp-content (optional - if you want existing content):**
   ```bash
   cp -r wp-content /path/to/new-project/
   ```

## Quick Setup Script

Create a minimal wp-config.php for Docker:

```php
<?php
define('DB_NAME', 'PROJECT_NAME_wordpress');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'db:3306');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// ... rest of wp-config.php ...
```

**Note:** Replace `PROJECT_NAME_wordpress` with your actual database name from docker-compose.yml.

## Troubleshooting "Nothing Renders"

1. **Check Docker logs:**

   ```bash
   docker-compose logs wordpress
   ```

2. **Check if containers are running:**

   ```bash
   docker-compose ps
   ```

3. **Check if wp-content exists:**

   ```bash
   ls -la wp-content/
   ```

4. **Check if wp-config.php exists:**

   ```bash
   ls -la wp-config.php
   ```

5. **Try accessing WordPress installer:**
   - Visit: http://localhost:8080/wp-admin/install.php
   - If you see WordPress installer, WordPress is working but not configured yet
