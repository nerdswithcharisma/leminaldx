/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './wp-content/themes/leminaldx-child/**/*.{php,js,jsx}',
    './src/**/*.{js,jsx,php,scss}',
  ],
  theme: {
    extend: {
      colors: {
        'brand-primary': '#000000',
        'brand-secondary': '#ffffff',
        'leminal-border': '#D1CE9E',
        'leminal-primary': '#233B9D',
        'leminal-arrow': '#919DCE',
        'primary-light': '#099EC9',
      },
    },
  },
  plugins: [],
};
