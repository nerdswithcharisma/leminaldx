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

### Deployment

After setting up the secrets, the workflow will automatically deploy when you push to main branch.

## How It Works

1. **Push to main branch** triggers the workflow
2. **Builds assets** with `npm run build`
3. **Deploys to FTP** using the FTP-Deploy-Action
4. **Uploads to**: `/YOUR_THEME_NAME/` directory on your FTP server

## Manual Deployment

If you need to deploy manually, you can use FTP client or command line tools.

## Troubleshooting

### Deployment Fails

1. **Check secrets are correct** in GitHub Settings → Secrets
2. **Verify server is accessible** - ping your FTP server
3. **Check FTP credentials** are correct
4. **Review workflow logs** in GitHub Actions tab

### Files Not Uploading

1. **Check server-dir path** - should match your theme directory
2. **Verify local-dir exists** - should be `./wp-content/themes/YOUR_THEME_NAME/`
3. **Check FTP user has write permissions**
4. **Verify protocol** - try `ftp` instead of `ftps` if connection fails

