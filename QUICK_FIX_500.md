# Quick Fix for 500 Error

## Most Common Cause: Missing or Wrong wp-config.php

The 500 error usually means WordPress can't connect to the database or wp-config.php is missing/wrong.

### Fix Steps:

1. **Check if wp-config.php exists:**
   ```bash
   ls -la wp-config.php
   ```

2. **If it doesn't exist, create it:**
   ```bash
   cp wp-config.php.template wp-config.php
   ```

3. **Update the database name in wp-config.php:**
   - Open `wp-config.php`
   - Find: `define( 'DB_NAME', 'PROJECT_NAME_wordpress' );`
   - Replace `PROJECT_NAME` with your actual project name from docker-compose.yml
   - Example: If docker-compose.yml has `WORDPRESS_DB_NAME: leminaldx_wordpress`, then use `leminaldx_wordpress`

4. **Check docker-compose.yml database name:**
   ```bash
   grep WORDPRESS_DB_NAME docker-compose.yml
   ```
   - Make sure wp-config.php DB_NAME matches this exactly

5. **Restart Docker:**
   ```bash
   docker-compose down
   docker-compose up -d
   ```

6. **Check logs for errors:**
   ```bash
   docker-compose logs wordpress --tail 50
   ```

7. **Try accessing WordPress installer:**
   - Visit: http://localhost:8080/wp-admin/install.php
   - If you see the installer, WordPress is working!

