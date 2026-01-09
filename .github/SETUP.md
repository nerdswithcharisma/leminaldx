# GitHub Actions Deployment Setup

## FTP Configuration

The GitHub Actions workflow deploys to FTP automatically when code is pushed to the main branch.

### Required GitHub Secrets

You need to set these secrets in your GitHub repository:

1. Go to: **Repository Settings** → **Secrets and variables** → **Actions** → **New repository secret**

2. Add these secrets:

- **FTP_USERNAME**: `YOUR_FTP_USERNAME`
- **FTP_PASSWORD**: `YOUR_FTP_PASSWORD`

### How to Add Secrets

1. Go to your GitHub repository
2. Click **Settings**
3. Click **Secrets and variables** → **Actions**
4. Click **New repository secret**
5. Name: `FTP_USERNAME`, Value: `your-ftp-username`
6. Click **Add secret**
7. Repeat for `FTP_PASSWORD`: `your-ftp-password`

### Optional: Slack Notifications

If you want Slack notifications on deployment success/failure:

1. Add secret: `SLACK_WEBHOOK_URL`
2. Uncomment the Slack notification steps in `.github/workflows/deploy.yml`

## Prerequisites

**Important:** WordPress must be installed manually on your FTP server before using this deployment workflow. The GitHub Actions workflow only deploys the `wp-content` directory and does not install WordPress core files.

### Manual WordPress Installation

1. Download WordPress from [wordpress.org](https://wordpress.org/download/)
2. Upload WordPress core files to your FTP server (typically to `htdocs/` or your web root)
3. Complete the WordPress installation via your browser
4. Once WordPress is installed, the GitHub Actions workflow will deploy your `wp-content` directory automatically

### Deployment

After setting up the secrets and installing WordPress manually on your server, the workflow will automatically deploy the `wp-content` directory when you push to the main branch.

**What gets deployed:**

- Only the `wp-content` directory (themes, plugins, etc.)
- WordPress core files are NOT deployed (must be installed manually)

## How It Works

1. **Push to main branch** triggers the workflow
2. **Builds assets** with `npm run build`
3. **Deploys to FTP** using the FTP-Deploy-Action
4. **Uploads only `wp-content` directory** to `htdocs/wp-content/` on your FTP server

## Manual Deployment

If you need to deploy manually, you can use FTP client or command line tools.

## Troubleshooting

### Deployment Fails

1. **Check secrets are correct** in GitHub Settings → Secrets
2. **Verify server is accessible** - ping your FTP server
3. **Check FTP credentials** are correct
4. **Review workflow logs** in GitHub Actions tab

### Files Not Uploading

1. **Check server-dir path** - should be `htdocs/wp-content/` (or `wp-content/` if `htdocs/` is your WordPress root)
2. **Verify WordPress is installed** - WordPress core must be installed manually before deployment
3. **Verify local wp-content directory exists** - should be `./wp-content` in your repository
4. **Check FTP user has write permissions** to the `wp-content` directory
5. **Verify protocol** - try `ftp` instead of `ftps` if connection fails
