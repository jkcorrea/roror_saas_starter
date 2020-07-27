const { environment } = require('@rails/webpacker')
const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin')

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
        ? { files: './app/javascript/**/*.{ts,tsx,js,jsx}' }
        : null,
    // Fail-fast in production
    async: process.env.NODE_ENV === 'development',
  }),
)

module.exports = environment
