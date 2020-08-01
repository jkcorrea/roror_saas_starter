const environment = require('./environment')

// eslint-disable-next-line import/no-extraneous-dependencies
const ReactRefreshWebpackPlugin = require('@pmmmwh/react-refresh-webpack-plugin')

const devBuild = process.env.NODE_ENV === 'development'
const isHMR = process.env.WEBPACK_DEV_SERVER

if (devBuild && !isHMR) {
  environment.loaders
    .get('sass')
    .use.find(
      (item) => item.loader === 'sass-loader',
    ).options.sourceMapContents = false
}

if (devBuild && isHMR) {
  environment.plugins.insert(
    'ReactRefreshWebpackPlugin',
    new ReactRefreshWebpackPlugin({
      overlay: {
        sockPort: 3035,
      },
    }),
  )

  const babelLoader = environment.loaders.get('babel')
  babelLoader.use[0].options.plugins = [].filter(Boolean)
  babelLoader.use[0].options.plugins.push(
    require.resolve('react-refresh/babel'),
  )
}

module.exports = environment
