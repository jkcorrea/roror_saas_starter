process.env.NODE_ENV = process.env.NODE_ENV || 'development'

// eslint-disable-next-line import/no-extraneous-dependencies
const ForkTsCheckerNotifierWebpackPlugin = require('fork-ts-checker-notifier-webpack-plugin')

const environment = require('./client')
const serverConfig = require('./server')
const { merge } = require('webpack-merge')

const optimization = {
  splitChunks: {
    chunks: 'async',
    cacheGroups: {
      vendor: {
        chunks: 'async',
        name: 'vendor',
        test: 'vendor',
        enforce: true,
      },
    },
  },
}

environment.splitChunks((config) => ({ ...config, optimization }))

environment.plugins.append(
  'ForkTsCheckerNotifierWebpackPlugin',
  new ForkTsCheckerNotifierWebpackPlugin(),
)

environment.config.merge({ devtool: 'eval-cheap-module-source-map' })

const clientConfig = merge(environment.toWebpackConfig(), {
  mode: 'development',
  output: {
    filename: '[name].js',
    chunkFilename: '[name].bundle.js',
    path: environment.config.output.path,
  },
})

// For HMR, we need to separate the the client and server webpack configurations
if (process.env.WEBPACK_DEV_SERVER) {
  module.exports = clientConfig
} else if (process.env.SERVER_BUNDLE_ONLY) {
  module.exports = serverConfig
} else {
  module.exports = [clientConfig, serverConfig]
}
