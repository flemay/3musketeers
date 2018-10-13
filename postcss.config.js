const tailwindcss = require('tailwindcss');
const autoprefixer = require('autoprefixer');
const purgecss = require('@fullhuman/postcss-purgecss');

/**
 * purgecss allows to shrink a lot the non-used CSS (tailwindcss is quite big)
 * https://tailwindcss.com/docs/controlling-file-size
 */
const pluginPurgeCSS = purgecss({
  content: ['layouts/**/*.html'],
  css: ['assets/css/main.css'],
  extractors: [{
    extractor: class {
      static extract(content) {
        return content.match(/[A-z0-9-:\/]+/g) || [];
      }
    },
    extensions: ['html']
  }]
});

const pluginAutoPrefixer = autoprefixer({
  browsers: [
    "Android 2.3",
    "Android >= 4",
    "Chrome >= 20",
    "Firefox >= 24",
    "Explorer >= 8",
    "iOS >= 6",
    "Opera >= 12",
    "Safari >= 6"
  ]
});

const plugins = [];
plugins.push(tailwindcss('./tailwind.js'));

if (process.env.ENV === 'development') {
  // don't purge css so that I can enjoy everything from tailwindcss
} else {
  // purge css so that it downsizes the css file a lot more
  plugins.push(pluginPurgeCSS);
}

plugins.push(pluginAutoPrefixer);

module.exports = {
  plugins
}