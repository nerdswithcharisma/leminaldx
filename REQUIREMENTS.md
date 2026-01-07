# Build Template Requirements

## Goal
Create a fully automated, self-contained WordPress build template that can be easily copied to new projects and set up with a single command.

## Current Problem
The template exists but the setup process is unreliable. Users have to manually copy files, replace placeholders, and configure WordPress. This needs to be 100% automated.

## Required Functionality

### 1. Single Command Setup
- User runs ONE command from their new project directory
- Script automatically:
  - Detects it's being run from a new project
  - Finds the build-template directory (should work from anywhere)
  - Copies all template files
  - Replaces ALL placeholders automatically
  - Creates all necessary directories
  - Creates wp-config.php with correct database name
  - Optionally downloads WordPress core files
  - Sets up everything ready to go

### 2. Template Files That Need Processing

**Root Config Files:**
- `package.json.template` → `package.json`
- `webpack.config.js.template` → `webpack.config.js`
- `tailwind.config.js.template` → `tailwind.config.js`
- `postcss.config.js.template` → `postcss.config.js`
- `docker-compose.yml.template` → `docker-compose.yml`
- `Dockerfile.template` → `Dockerfile`
- `.gitignore.template` → `.gitignore`
- `.dockerignore.template` → `.dockerignore`
- `wp-config.php.template` → `wp-config.php`

**GitHub Actions (Optional):**
- `.github/workflows/deploy.yml.template` → `.github/workflows/deploy.yml`
- `.github/SETUP.md.template` → `.github/SETUP.md`

**Source Files:**
- `src/js/theme-name.js.template` → `src/js/{THEME_NAME}.js`
- `src/js/admin.js.template` → `src/js/admin.js`
- `src/scss/theme-name.scss.template` → `src/scss/{THEME_NAME}.scss`

### 3. Placeholders to Replace

**PROJECT_NAME** - Used in:
- `docker-compose.yml` (container names, database name)
- `wp-config.php` (database name)
- `.github/workflows/deploy.yml` (if using GitHub Actions)

**YOUR_THEME_NAME** - Used in:
- `webpack.config.js` (output path, devServer directory)
- `tailwind.config.js` (content paths)
- `.gitignore` (dist path)
- `.dockerignore` (dist path)
- `.github/workflows/deploy.yml` (server-dir, local-dir)

**THEME_NAME** - Used in:
- `src/js/theme-name.js.template` (import path: `import '../scss/THEME_NAME.scss'`)
- `webpack.config.js` (entry point name)

**YOUR_FTP_SERVER** - Used in:
- `.github/workflows/deploy.yml` (server IP/hostname)

### 4. Directory Structure to Create

```
project-root/
├── src/
│   ├── js/
│   │   ├── {THEME_NAME}.js
│   │   └── admin.js
│   └── scss/
│       └── {THEME_NAME}.scss
└── wp-content/
    ├── themes/
    ├── plugins/
    └── uploads/
```

### 5. WordPress Setup

**Required:**
- Create `wp-config.php` with database name matching `docker-compose.yml`
- Create `wp-content` directory structure
- Optionally download WordPress core files (wp-admin, wp-includes, wp-*.php, index.php)

**Database Configuration:**
- Database name in `wp-config.php` must match `WORDPRESS_DB_NAME` in `docker-compose.yml`
- Format: `{PROJECT_NAME}_wordpress`
- Example: If PROJECT_NAME is "leminaldx", DB_NAME should be "leminaldx_wordpress"

### 6. Setup Script Requirements

**Inputs Needed:**
1. Project name (e.g., "leminaldx")
2. Theme name (e.g., "leminaldx-theme")
3. FTP server (optional, for GitHub Actions)

**What Script Must Do:**
1. Find build-template directory (even if run from project directory)
2. Copy all template files to project directory
3. Replace ALL placeholders in ALL files
4. Rename files (remove .template extension)
5. Create all directories
6. Create source files with correct names
7. Update webpack.config.js entry points
8. Create wp-config.php with correct database name
9. Create wp-content directories
10. Optionally download WordPress
11. Provide clear next steps

**Script Location:**
- Should work when run from:
  - Project directory (new project)
  - build-template directory
  - Anywhere (if build-template path is provided)

### 7. WordPress Download Script

**Requirements:**
- Download latest WordPress from wordpress.org
- Extract to project directory
- Skip wp-content if it already exists (don't overwrite)
- Work from any directory
- Show progress
- Handle errors gracefully

### 8. Error Handling

**Must Handle:**
- Missing template files
- Invalid project/theme names
- Directory permission issues
- Network errors (WordPress download)
- Existing files (ask before overwriting or skip)

### 9. User Experience

**Ideal Flow:**
```bash
cd /path/to/new-project
bash /path/to/build-template/setup.sh
# OR
cp -r build-template/* .
bash setup.sh
```

**Script should:**
- Ask for project name
- Ask for theme name
- Ask if want to download WordPress
- Do everything else automatically
- Show clear progress messages
- Provide clear next steps at the end

### 10. Testing Scenarios

**Must Work:**
1. Run from empty project directory
2. Run from project directory with some files already
3. Run from build-template directory
4. Run with absolute paths
5. Run with relative paths
6. Handle spaces in paths
7. Handle special characters in project/theme names

### 11. Documentation

**Required Files:**
- `README.md` - Complete setup instructions
- `REQUIREMENTS.md` - This file
- Clear comments in scripts
- Error messages that help users fix issues

### 12. Current Issues to Fix

1. Script can't find template files when run from project directory
2. Placeholders not being replaced correctly
3. WordPress download script doesn't work reliably
4. wp-config.php not created automatically
5. Database name mismatch causes 500 errors
6. Too many manual steps required

### 13. Success Criteria

**Setup is successful when:**
- User runs one command
- All files are copied and configured
- wp-config.php exists with correct database name
- User can run `npm install && npm run build && docker-compose up -d`
- WordPress loads at http://localhost:8080 (or configured port)
- No manual file editing required
- No manual placeholder replacement required

## Technical Constraints

- Must work on macOS and Linux
- Must use bash (not zsh-specific features)
- Must handle both sed -i '' (macOS) and sed -i (Linux)
- Must not require sudo
- Must not modify files outside project directory
- Must be idempotent (can be run multiple times safely)

## Files to Create/Modify

1. `setup.sh` - Main setup script (needs complete rewrite)
2. `download-wordpress.sh` - WordPress download (needs fixes)
3. `README.md` - Update with correct instructions
4. All template files - Ensure all placeholders are consistent

## Priority

**Critical (Must Have):**
- Single command setup
- Automatic placeholder replacement
- Automatic wp-config.php creation
- Directory creation
- Clear error messages

**Important (Should Have):**
- WordPress download automation
- GitHub Actions setup
- Progress indicators
- Validation of inputs

**Nice to Have:**
- Interactive menu
- Dry-run mode
- Rollback capability
- Multiple project support

