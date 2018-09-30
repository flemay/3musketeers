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

// Only purgecss if ENV is prod so that in other environments there is no need to restart the container when adding new styles to take effect.
if (process.env.ENV === 'prod') {
  plugins.push(pluginPurgeCSS);
}

plugins.push(pluginAutoPrefixer);

module.exports = {
  plugins
}