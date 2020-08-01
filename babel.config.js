module.exports = (api) => {
  const validEnv = ['development', 'test', 'production']
  const currentEnv = api.env()
  api.cache.using(() => currentEnv)
  const isDev = api.env('development')
  const isProd = api.env('production')
  const isTest = api.env('test')
  const isHMR = process.env.WEBPACK_DEV_SERVER

  if (!validEnv.includes(currentEnv)) {
    throw new Error(
      `${
        'Please specify a valid `NODE_ENV` or ' +
        '`BABEL_ENV` environment variables. Valid values are "development", ' +
        '"test", and "production". Instead, received: '
      }${JSON.stringify(currentEnv)}.`,
    )
  }

  return {
    presets: [
      isTest && [
        '@babel/preset-env',
        {
          targets: {
            node: 'current',
          },
          modules: 'commonjs',
        },
        '@babel/preset-react',
      ],
      (isProd || isDev) && [
        '@babel/preset-env',
        {
          useBuiltIns: 'entry',
          corejs: 3,
          modules: false,
          bugfixes: true,
          loose: true,
          exclude: ['transform-typeof-symbol'],
        },
      ],
      [
        '@babel/preset-react',
        {
          development: isDev || isTest,
          useBuiltIns: true,
        },
      ],
    ].filter(Boolean),
    plugins: [
      isDev && isHMR && 'react-refresh/babel',
      'babel-plugin-macros',
      '@babel/plugin-syntax-dynamic-import',
      '@babel/plugin-transform-destructuring',
      [
        '@babel/plugin-proposal-class-properties',
        {
          loose: true,
        },
      ],
      [
        '@babel/plugin-proposal-object-rest-spread',
        {
          useBuiltIns: true,
        },
      ],
      [
        '@babel/plugin-transform-runtime',
        {
          helpers: false,
          regenerator: true,
          corejs: false,
        },
      ],
      [
        '@babel/plugin-transform-regenerator',
        {
          async: false,
        },
      ],
      isProd && [
        'babel-plugin-transform-react-remove-prop-types',
        {
          removeImport: true,
        },
      ],
    ].filter(Boolean),
  }
}
