/* eslint-disable import/no-extraneous-dependencies */
/* eslint-disable global-require */

const environment = {
  plugins: [
    require('tailwindcss'),
    require('autoprefixer'),
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009',
      },
      stage: 3,
    }),
  ],
}

// if (process.env.RAILS_ENV === 'production') {
//   environment.plugins.push(
//     require('@fullhuman/postcss-purgecss')({
//       content: [
//         './app/**/*.haml',
//         './app/**/*.html.erb',
//         './app/**/*.html.slim',
//         './app/helpers/**/*.rb',
//         './app/javascript/**/*.js',
//         './app/javascript/**/*.jsx',
//         './app/javascript/**/*.ts',
//         './app/javascript/**/*.tsx',
//       ],
//       defaultExtractor: (content) => content.match(/[A-Za-z0-9-_:/]+/g) || [],
//     }),
//   )
// }

module.exports = environment
