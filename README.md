# WordPress + Astra Theme Setup

Simple, automated setup for a new WordPress project with Astra theme and child theme.

## Quick Start

1. **Navigate to your new project directory:**

   ```bash
   cd /path/to/your/new-project
   ```

2. **Run the setup script:**

   ```bash
   bash /path/to/build-template/setup.sh
   ```

   Or if you've copied the script to your project:

   ```bash
   bash setup.sh
   ```

3. **Enter your project name when prompted** (e.g., `leminaldx`)

4. **Follow the on-screen instructions:**
   - Start Docker: `docker-compose up -d`
   - Visit: `http://localhost:8080`
   - Complete WordPress installation in your browser
   - Activate your child theme

## What It Does

- ✅ Downloads latest WordPress
- ✅ Downloads and installs Astra theme
- ✅ Creates a child theme for your project
- ✅ Creates `wp-config.php` with correct database settings
- ✅ Creates `docker-compose.yml` for local development
- ✅ Sets everything up ready to go

## Requirements

- Docker and Docker Compose
- `curl` and `unzip` (usually pre-installed)
- Internet connection (for downloading WordPress and Astra)

## That's It!

No manual configuration needed. Just run the script and follow the prompts.
