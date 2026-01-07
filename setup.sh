#!/bin/bash

# WordPress + Astra Theme Setup Script
# This script sets up a complete WordPress project with Astra theme and child theme

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     WordPress + Astra Theme Automated Setup            ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

# Get project directory (where script is run from)
PROJECT_DIR="$( pwd )"

# Get project name
read -p "Enter your project name (e.g., leminaldx): " PROJECT_NAME

if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name is required${NC}"
    exit 1
fi

# Sanitize project name (lowercase, no spaces)
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')

echo ""
echo -e "${YELLOW}Setting up project: ${PROJECT_NAME}${NC}"
echo -e "${YELLOW}Project directory: ${PROJECT_DIR}${NC}"
echo ""

# Step 1: Download WordPress
echo -e "${GREEN}[1/4] Downloading WordPress...${NC}"
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

echo "Downloading latest WordPress..."
curl -L -o wordpress.tar.gz "https://wordpress.org/latest.tar.gz"

echo "Extracting WordPress..."
tar -xzf wordpress.tar.gz

echo "Copying WordPress files to project..."
cd "$PROJECT_DIR"
cp -r "$TMP_DIR/wordpress"/* .

# Cleanup temp
rm -rf "$TMP_DIR"

echo -e "${GREEN}✓ WordPress downloaded${NC}"
echo ""

# Step 2: Download Astra Theme
echo -e "${GREEN}[2/4] Downloading Astra Theme...${NC}"
cd wp-content/themes

echo "Downloading Astra theme..."
curl -L -o astra.zip "https://downloads.wordpress.org/theme/astra.latest-stable.zip"

echo "Extracting Astra theme..."
unzip -q astra.zip
rm astra.zip

echo -e "${GREEN}✓ Astra theme installed${NC}"
echo ""

# Step 3: Create Child Theme
echo -e "${GREEN}[3/4] Creating child theme...${NC}"
CHILD_THEME_NAME="${PROJECT_NAME}-child"
# Capitalize first letter for display (works on macOS bash 3.2+)
THEME_DISPLAY_NAME=$(echo "$PROJECT_NAME" | awk '{print toupper(substr($0,1,1)) substr($0,2)}')
mkdir -p "$CHILD_THEME_NAME"

# Create style.css
cat > "$CHILD_THEME_NAME/style.css" << EOF
/*
Theme Name: ${THEME_DISPLAY_NAME} Child
Template: astra
Description: Child theme for ${PROJECT_NAME}
Version: 1.0.0
*/
EOF

# Create functions.php
cat > "$CHILD_THEME_NAME/functions.php" << EOF
<?php
/**
 * Child theme functions
 */

// Enqueue parent theme styles
function child_enqueue_styles() {
    wp_enqueue_style('parent-style', get_template_directory_uri() . '/style.css');

    // Enqueue built CSS and JS (after npm run build)
    wp_enqueue_style('child-theme-style', get_stylesheet_directory_uri() . '/dist/css/${CHILD_THEME_NAME}.bundle.css', array('parent-style'), '1.0.0');
    wp_enqueue_script('child-theme-script', get_stylesheet_directory_uri() . '/dist/js/${CHILD_THEME_NAME}.bundle.js', array('jquery'), '1.0.0', true);
}
add_action('wp_enqueue_scripts', 'child_enqueue_styles');
EOF

# Create index.php
cat > "$CHILD_THEME_NAME/index.php" << 'EOF'
<?php
/**
 * The main template file
 */
get_header();
?>

<main>
    <?php
    if (have_posts()) :
        while (have_posts()) :
            the_post();
            the_content();
        endwhile;
    endif;
    ?>
</main>

<?php
get_footer();
EOF

echo -e "${GREEN}✓ Child theme created: ${CHILD_THEME_NAME}${NC}"
echo ""

# Step 4: Create wp-config.php
echo -e "${GREEN}[4/4] Creating wp-config.php...${NC}"
cd "$PROJECT_DIR"

DB_NAME="${PROJECT_NAME}_wordpress"

cat > wp-config.php << EOF
<?php
/**
 * WordPress Configuration
 * Project: ${PROJECT_NAME}
 */

// Database settings
define('DB_NAME', '${DB_NAME}');
define('DB_USER', 'wordpress');
define('DB_PASSWORD', 'wordpress');
define('DB_HOST', 'db:3306');
define('DB_CHARSET', 'utf8mb4');
define('DB_COLLATE', '');

// WordPress Database Table prefix
\$table_prefix = 'wp_';

// Debugging
define('WP_DEBUG', true);
define('WP_DEBUG_LOG', true);
define('WP_DEBUG_DISPLAY', false);

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

// Absolute path to WordPress directory
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}

require_once ABSPATH . 'wp-settings.php';
EOF

echo -e "${GREEN}✓ wp-config.php created${NC}"
echo ""

# Create docker-compose.yml
echo "Creating docker-compose.yml..."
cat > docker-compose.yml << EOF
services:
  wordpress:
    image: wordpress:6.4-php8.2-apache
    platform: linux/amd64
    container_name: ${PROJECT_NAME}-wordpress
    restart: unless-stopped
    ports:
      - "8080:80"
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: ${DB_NAME}
      WORDPRESS_DEBUG: 1
    volumes:
      - ./wp-content:/var/www/html/wp-content
      - ./wp-config.php:/var/www/html/wp-config.php
    depends_on:
      - db

  db:
    image: mysql:8.0
    platform: linux/amd64
    container_name: ${PROJECT_NAME}-mysql
    restart: unless-stopped
    environment:
      MYSQL_DATABASE: ${DB_NAME}
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
      MYSQL_ROOT_PASSWORD: rootpassword
    volumes:
      - mysql_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    platform: linux/amd64
    container_name: ${PROJECT_NAME}-phpmyadmin
    restart: unless-stopped
    ports:
      - "8081:80"
    environment:
      PMA_HOST: db
      PMA_USER: wordpress
      PMA_PASSWORD: wordpress
    depends_on:
      - db

volumes:
  mysql_data:
EOF

echo -e "${GREEN}✓ docker-compose.yml created${NC}"
echo ""

# Step 5: Create Front-End Build Setup
echo -e "${GREEN}[5/5] Setting up front-end build (Webpack, Tailwind, React)...${NC}"

# Create package.json
cat > package.json << EOF
{
  "name": "${PROJECT_NAME}",
  "version": "1.0.0",
  "description": "WordPress theme with React and Tailwind",
  "scripts": {
    "dev": "webpack serve --mode development",
    "build": "webpack --mode production",
    "watch": "webpack --mode development --watch"
  },
  "devDependencies": {
    "@babel/core": "^7.23.0",
    "@babel/preset-env": "^7.23.0",
    "@babel/preset-react": "^7.22.0",
    "autoprefixer": "^10.4.16",
    "babel-loader": "^9.1.3",
    "css-loader": "^6.8.1",
    "mini-css-extract-plugin": "^2.7.6",
    "postcss": "^8.4.31",
    "postcss-loader": "^7.3.3",
    "sass": "^1.69.5",
    "sass-loader": "^13.3.2",
    "style-loader": "^3.3.3",
    "tailwindcss": "^3.3.5",
    "webpack": "^5.89.0",
    "webpack-cli": "^5.1.4",
    "webpack-dev-server": "^4.15.1"
  },
  "dependencies": {
    "@wordpress/element": "^5.0.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
EOF

# Create webpack.config.js
cat > webpack.config.js << EOF
const path = require('path');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = (env, argv) => {
  return {
    entry: {
      '${CHILD_THEME_NAME}': './src/js/${CHILD_THEME_NAME}.js',
      'admin': './src/js/admin.js',
    },
    output: {
      path: path.resolve(__dirname, 'wp-content/themes/${CHILD_THEME_NAME}/dist'),
      filename: 'js/[name].bundle.js',
      clean: true,
    },
    module: {
      rules: [
        {
          test: /\.(js|jsx)$/,
          exclude: /node_modules/,
          use: {
            loader: 'babel-loader',
            options: {
              presets: ['@babel/preset-env', '@babel/preset-react'],
            },
          },
        },
        {
          test: /\.(scss|css)$/,
          use: [
            MiniCssExtractPlugin.loader,
            'css-loader',
            'postcss-loader',
            'sass-loader',
          ],
        },
        {
          test: /\.(png|jpg|jpeg|gif|svg)$/,
          type: 'asset/resource',
          generator: {
            filename: 'images/[name][ext]',
          },
        },
      ],
    },
    plugins: [
      new MiniCssExtractPlugin({
        filename: 'css/[name].bundle.css',
      }),
    ],
    resolve: {
      extensions: ['.js', '.jsx'],
    },
    devServer: {
      static: {
        directory: path.join(__dirname, 'wp-content/themes/${CHILD_THEME_NAME}'),
      },
      compress: true,
      port: 3000,
      hot: true,
    },
  };
};
EOF

# Create tailwind.config.js
cat > tailwind.config.js << EOF
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './wp-content/themes/${CHILD_THEME_NAME}/**/*.{php,js,jsx}',
    './src/**/*.{js,jsx,php}',
  ],
  theme: {
    extend: {
      colors: {
        'brand-primary': '#000000',
        'brand-secondary': '#ffffff',
      },
    },
  },
  plugins: [],
};
EOF

# Create postcss.config.js
cat > postcss.config.js << EOF
module.exports = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
EOF

# Create .gitignore
cat > .gitignore << EOF
# Dependencies
node_modules/
npm-debug.log*

# Build outputs
wp-content/themes/${CHILD_THEME_NAME}/dist/
*.log

# Environment
.env
.env.local

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db

# WordPress
wp-content/uploads/
wp-content/cache/
EOF

# Create source directories and files
mkdir -p src/js src/scss

# Create main theme JS file
cat > "src/js/${CHILD_THEME_NAME}.js" << EOF
// Main theme JavaScript
import '../scss/${CHILD_THEME_NAME}.scss';

// Optional: Import React if needed
// import React from 'react';
// import { createRoot } from 'react-dom/client';

console.log('${CHILD_THEME_NAME} theme loaded');

// Your theme JavaScript code here
document.addEventListener('DOMContentLoaded', function () {
  // Initialize your code here
});
EOF

# Create admin JS file
cat > src/js/admin.js << 'EOF'
// Admin-specific JavaScript
console.log('Admin scripts loaded');
EOF

# Create main SCSS file
cat > "src/scss/${CHILD_THEME_NAME}.scss" << EOF
// Main theme stylesheet
@tailwind base;
@tailwind components;
@tailwind utilities;

// Your custom styles here
EOF

echo -e "${GREEN}✓ Front-end build setup created${NC}"
echo ""

# Success message
echo -e "${BLUE}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                  Setup Complete!                        ║${NC}"
echo -e "${BLUE}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo -e "${GREEN}1. Install front-end dependencies:${NC}"
echo "   ${BLUE}npm install${NC}"
echo ""
echo -e "${GREEN}2. Build front-end assets:${NC}"
echo "   ${BLUE}npm run build${NC}"
echo ""
echo -e "${GREEN}3. Start Docker:${NC}"
echo "   ${BLUE}docker-compose up -d${NC}"
echo ""
echo -e "${GREEN}4. Wait for containers to start (about 10-15 seconds)${NC}"
echo ""
echo -e "${GREEN}5. Visit your browser and go through WordPress installation:${NC}"
echo "   ${BLUE}http://localhost:8080${NC}"
echo ""
echo -e "${YELLOW}WordPress will guide you through:${NC}"
echo "   • Language selection"
echo "   • Database connection (already configured)"
echo "   • Site title, admin username, password"
echo "   • Email address"
echo ""
echo -e "${GREEN}6. After WordPress is installed:${NC}"
echo "   • Go to ${BLUE}Appearance > Themes${NC}"
echo "   • Activate ${BLUE}${THEME_DISPLAY_NAME} Child${NC} theme"
echo ""
echo -e "${YELLOW}That's it! Your WordPress site is ready.${NC}"
echo ""
