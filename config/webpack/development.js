process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')
const ForkTsCheckerNotifierWebpackPlugin = require('fork-ts-checker-notifier-webpack-plugin')

environment.plugins.append(
  'ForkTsCheckerNotifierWebpackPlugin',
  new ForkTsCheckerNotifierWebpackPlugin(),
)

environment.config.merge({ devtool: 'eval-cheap-module-source-map' })

module.exports = environment.toWebpackConfig()
