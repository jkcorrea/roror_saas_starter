const { environment } = require('@rails/webpacker')

// eslint-disable-next-line import/no-extraneous-dependencies
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin')

const MAX_INLINE_FILE_SIZE = 1000 // below 10k, inline, small 1K is to test file loader
const SASS_RESOURCES_FILE = './client/assets/styles/app-variables.scss'

const rules = environment.loaders
const fileLoader = rules.get('file')
const babelLoader = rules.get('babel')
const cssLoader = rules.get('css')
const sassLoader = rules.get('sass')
const ManifestPlugin = environment.plugins.get('Manifest')

// TypeScript Loaders
environment.loaders.append('typescript', {
  test: /.(ts|tsx)$/,
  use: [{ loader: 'ts-loader', options: { transpileOnly: true } }],
})

// Adding this here so all envs pick it up without repeating too much code
// but we'll still have to check the env for some flags..
environment.plugins.append(
  'ForkTsCheckerWebpackPlugin',
  new ForkTsCheckerWebpackPlugin({
    // Lint in dev
    eslint:
      process.env.NODE_ENV === 'development'
        ? { files: './client/**/*.{ts,tsx}' }
        : null,
    // Fail-fast in production
    async: process.env.NODE_ENV === 'development',
  }),
)

// TODO https://github.com/rails/webpacker/blob/master/docs/css.md
// Add typings for CSS imports https://medium.com/@sapegin/css-modules-with-typescript-and-webpack-6b221ebe5f10
// const typingsForCSSModulesLoader = {
//   loader: '@teamsupercell/typings-for-css-modules-loader',
//   options: {
//     banner:
//       '// THIS FILE IS AUTOGENERATED!\n// Please do not change this file!',
//   },
// }
// cssLoader.use.append(typingsForCSSModulesLoader)

// Asset loaders
sassLoader.use.push({
  loader: 'sass-resources-loader',
  options: {
    resources: SASS_RESOURCES_FILE,
  },
})
const urlLoader = {
  test: /\.(jpe?g|png|gif|ico|woff|woff2)$/,
  use: {
    loader: 'url-loader',
    options: {
      limit: MAX_INLINE_FILE_SIZE,
      // NO leading slash
      name: 'images/[name]-[hash].[ext]',
    },
  },
}
environment.loaders.insert('url', urlLoader, { before: 'file' })

// changing order of babelLoader
environment.loaders.insert('babel', babelLoader, { before: 'css' })

// modifying modules in css and sass to true,
cssLoader.use[1].options.modules = true
sassLoader.use[1].options.modules = true

// changing fileLoader to use proper values
fileLoader.test = /\.(ttf|eot|svg)$/
fileLoader.use[0].options = { name: 'images/[name]-[hash].[ext]' }

rules.delete('nodeModules')
rules.delete('moduleCss')
rules.delete('moduleSass')

ManifestPlugin.options.writeToFileEmit = true

module.exports = environment
