#!/bin/bash

# Simple WordPress Build Template Setup
# Run this from your project directory

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🚀 WordPress Build Template Setup${NC}"
echo ""

# Get project directory (where script is run from)
PROJECT_DIR="$( pwd )"
TEMPLATE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Project directory: $PROJECT_DIR"
echo "Template directory: $TEMPLATE_DIR"
echo ""

# Get inputs
read -p "Enter your project name (e.g., leminaldx): " PROJECT_NAME
read -p "Enter your theme name (e.g., leminaldx-theme): " THEME_NAME

if [ -z "$PROJECT_NAME" ] || [ -z "$THEME_NAME" ]; then
    echo -e "${RED}Error: Project name and theme name are required${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Setting up: ${PROJECT_NAME} with theme: ${THEME_NAME}${NC}"
echo ""

# Function to copy and process template
process_file() {
    local src="$1"
    local dest="$2"
    
    if [ -f "$src" ]; then
        cp "$src" "$dest"
        # Replace placeholders
        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/PROJECT_NAME/${PROJECT_NAME}/g" "$dest"
            sed -i '' "s/YOUR_THEME_NAME/${THEME_NAME}/g" "$dest"
            sed -i '' "s/THEME_NAME/${THEME_NAME}/g" "$dest"
        else
            sed -i "s/PROJECT_NAME/${PROJECT_NAME}/g" "$dest"
            sed -i "s/YOUR_THEME_NAME/${THEME_NAME}/g" "$dest"
            sed -i "s/THEME_NAME/${THEME_NAME}/g" "$dest"
        fi
        echo -e "${GREEN}✓${NC} Created $(basename $dest)"
    fi
}

# Copy all template files
echo "Copying template files..."
process_file "$TEMPLATE_DIR/package.json.template" "$PROJECT_DIR/package.json"
process_file "$TEMPLATE_DIR/webpack.config.js.template" "$PROJECT_DIR/webpack.config.js"
process_file "$TEMPLATE_DIR/tailwind.config.js.template" "$PROJECT_DIR/tailwind.config.js"
process_file "$TEMPLATE_DIR/postcss.config.js.template" "$PROJECT_DIR/postcss.config.js"
process_file "$TEMPLATE_DIR/docker-compose.yml.template" "$PROJECT_DIR/docker-compose.yml"
process_file "$TEMPLATE_DIR/Dockerfile.template" "$PROJECT_DIR/Dockerfile"
process_file "$TEMPLATE_DIR/.gitignore.template" "$PROJECT_DIR/.gitignore"
process_file "$TEMPLATE_DIR/.dockerignore.template" "$PROJECT_DIR/.dockerignore"
process_file "$TEMPLATE_DIR/wp-config.php.template" "$PROJECT_DIR/wp-config.php"

# Create directories
echo ""
echo "Creating directories..."
mkdir -p "$PROJECT_DIR/src/js"
mkdir -p "$PROJECT_DIR/src/scss"
mkdir -p "$PROJECT_DIR/wp-content/themes"
mkdir -p "$PROJECT_DIR/wp-content/plugins"
mkdir -p "$PROJECT_DIR/wp-content/uploads"

# Copy source files
echo "Creating source files..."
process_file "$TEMPLATE_DIR/src/js/theme-name.js.template" "$PROJECT_DIR/src/js/${THEME_NAME}.js"
process_file "$TEMPLATE_DIR/src/js/admin.js.template" "$PROJECT_DIR/src/js/admin.js"
process_file "$TEMPLATE_DIR/src/scss/theme-name.scss.template" "$PROJECT_DIR/src/scss/${THEME_NAME}.scss"

# Update webpack entry
if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' "s/theme-name/${THEME_NAME}/g" "$PROJECT_DIR/webpack.config.js"
else
    sed -i "s/theme-name/${THEME_NAME}/g" "$PROJECT_DIR/webpack.config.js"
fi

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo "Next steps:"
echo "1. Install dependencies: ${YELLOW}npm install${NC}"
echo "2. Download WordPress: ${YELLOW}bash $TEMPLATE_DIR/download-wordpress.sh${NC}"
echo "3. Build assets: ${YELLOW}npm run build${NC}"
echo "4. Start Docker: ${YELLOW}docker-compose up -d${NC}"
echo "5. Visit: ${YELLOW}http://localhost:8080${NC}"
echo ""

