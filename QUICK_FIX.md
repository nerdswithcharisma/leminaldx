# Quick Fix for Manual Setup

If you manually copied template files and are getting import errors, you need to:

1. **Update the import path in your JS file** to match your actual theme name:

```js
// In src/js/YOUR_THEME_NAME.js
// Change this:
import '../scss/theme-name.scss';

// To this (replace YOUR_THEME_NAME with your actual theme name):
import '../scss/YOUR_THEME_NAME.scss';
```

2. **Make sure your SCSS file exists** at `src/scss/YOUR_THEME_NAME.scss`

3. **Update webpack.config.js entry** to match your theme name:

```js
entry: {
  'YOUR_THEME_NAME': './src/js/YOUR_THEME_NAME.js',
  'admin': './src/js/admin.js',
}
```

**Better solution:** Use the automated setup script instead:
```bash
cd build-template
./setup.sh
```

