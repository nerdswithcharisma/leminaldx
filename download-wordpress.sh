#!/bin/bash

# Download WordPress Core Files
# This script downloads the latest WordPress core files to your project

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}📥 Downloading WordPress...${NC}"
echo ""

# Save the directory where we're running from
ORIGINAL_DIR="$( pwd )"

# Get project directory - use current directory by default
TARGET_DIR="$ORIGINAL_DIR"

# If a directory was passed as argument, use it
if [ -n "$1" ] && [ -d "$1" ]; then
    TARGET_DIR="$1"
    # Convert relative path to absolute
    if [[ ! "$TARGET_DIR" = /* ]]; then
        TARGET_DIR="$ORIGINAL_DIR/$TARGET_DIR"
    fi
    WP_VERSION="latest"
else
    WP_VERSION=${1:-"latest"}
fi

echo -e "${GREEN}Installing WordPress to: ${TARGET_DIR}${NC}"
echo ""

if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory does not exist: $TARGET_DIR${NC}"
    exit 1
fi

if [ "$WP_VERSION" = "latest" ]; then
    echo "Downloading latest WordPress..."
    WP_URL="https://wordpress.org/latest.tar.gz"
else
    echo "Downloading WordPress ${WP_VERSION}..."
    WP_URL="https://wordpress.org/wordpress-${WP_VERSION}.tar.gz"
fi

# Create temp directory
TMP_DIR=$(mktemp -d)
cd "$TMP_DIR"

# Download WordPress
echo "Downloading from ${WP_URL}..."
curl -L -o wordpress.tar.gz "$WP_URL"

# Extract
echo "Extracting..."
tar -xzf wordpress.tar.gz

# Copy WordPress core files (skip wp-content if it exists)
if [ -d "$TARGET_DIR/wp-content" ]; then
    echo "wp-content exists, skipping..."
    cp -r wordpress/wp-admin "$TARGET_DIR/"
    cp -r wordpress/wp-includes "$TARGET_DIR/"
    cp wordpress/wp-*.php "$TARGET_DIR/"
    cp wordpress/index.php "$TARGET_DIR/"
    cp wordpress/xmlrpc.php "$TARGET_DIR/" 2>/dev/null || true
    cp wordpress/license.txt "$TARGET_DIR/" 2>/dev/null || true
    cp wordpress/readme.html "$TARGET_DIR/" 2>/dev/null || true
else
    # Copy everything
    cp -r wordpress/* "$TARGET_DIR/"
fi

# Cleanup
cd "$ORIGINAL_DIR"
rm -rf "$TMP_DIR"

echo -e "${GREEN}✅ WordPress downloaded successfully!${NC}"
echo ""
echo "Next steps:"
echo "1. Make sure wp-config.php exists (copy from wp-config.php.template)"
echo "2. Create wp-content directories: mkdir -p wp-content/themes wp-content/plugins wp-content/uploads"
echo "3. Start Docker: docker-compose up -d"
echo "4. Visit http://localhost:8080"

