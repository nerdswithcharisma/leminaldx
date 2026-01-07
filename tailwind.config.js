/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    './wp-content/themes/leminaldx-child/**/*.{php,js,jsx}',
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
