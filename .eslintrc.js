module.exports = {
  root: true,
  parser: '@typescript-eslint/parser',
  parserOptions: {
    ecmaVersion: 2018,
    sourceType: 'module',
    ecmaFeatures: {
      jsx: true,
    },
    project: './tsconfig.eslint.json',
  },
  extends: [
    'airbnb-typescript',
    'plugin:@typescript-eslint/eslint-recommended',
    'plugin:eslint-comments/recommended',
    'plugin:jest/recommended',
    'plugin:promise/recommended',
    'plugin:unicorn/recommended',
    'prettier',
    'prettier/react',
    'prettier/@typescript-eslint',
  ],
  plugins: [
    '@typescript-eslint',
    'eslint-comments',
    'jest',
    'promise',
    'unicorn',
    'simple-import-sort',
  ],
  env: {
    node: true,
    browser: true,
    jest: true,
    es6: true,
  },
  rules: {
    // General rules
    'spaced-comment': [
      'error',
      'always',
      { markers: ['/', '#region'], exceptions: ['#endregion'] },
    ], // allow typescript `///`
    'no-underscore-dangle': 'off', // I like the semantics of these (e.g. unused, __DEV__)
    // Too restrictive, writing ugly code to defend against a very unlikely scenario: https://eslint.org/docs/rules/no-prototype-builtins
    'no-prototype-builtins': 'off',
    // https://basarat.gitbooks.io/typescript/docs/tips/defaultIsBad.html
    'promise/catch-or-return': 'off',
    'class-methods-use-this': 'off',
    'unicorn/no-null': 'off',
    'unicorn/no-fn-reference-in-iterator': 'off',
    'import/extensions': 'off',

    // Imports
    'simple-import-sort/sort': [
      'error',
      {
        groups: [
          // Side effect imports first
          ['^\\u0000'],
          // React first, then any other packages
          ['^react$', '^(?!@app)@?\\w'],
          // Absolute imports (doesn't start with .)
          ['^[^.]'],
          // Relative imports
          [
            // ../whatever/
            '^\\.\\./(?=.*/)',
            // ../
            '^\\.\\./',
            // ./whatever/
            '^\\./(?=.*/)',
            // Anything that starts with a dot
            '^\\.',
          ],
          // Asset imports
          ['^.+\\.(html|scss|sass|css|json|gql|graphql|md)$'],
        ],
      },
    ],
    'sort-imports': 'off', // use above
    'import/order': 'off', // use above
    'import/no-default-export': 'off',
    'import/prefer-default-export': 'off',

    // React
    'react/prop-types': 'off',
    // PascalCase naming
    'react/jsx-pascal-case': 'error',
    // Too restrictive: https://github.com/yannickcr/eslint-plugin-react/blob/master/docs/rules/destructuring-assignment.md
    'react/destructuring-assignment': 'off',
    'react/jsx-props-no-spreading': 'off',
    'react/jsx-filename-extension': ['error', { extensions: ['.tsx'] }],

    // Use function hoisting to improve code readability
    'no-use-before-define': [
      'error',
      { functions: false, classes: true, variables: true },
    ],

    // File / naming conventions
    'unicorn/filename-case': [
      'error',
      {
        cases: {
          pascalCase: true,
          kebabCase: true,
          snakeCase: false,
          camelCase: false,
        },
        // eslint-disable-next-line unicorn/better-regex
        ignore: [/^(\[\w+\]\.tsx?|\d+-\w+\.(ts|js))$/],
      },
    ],
    // Common abbreviations are known and readable
    'unicorn/prevent-abbreviations': 'off',
    'unicorn/consistent-function-scoping': 'off',
    'eslint-comments/disable-enable-pair': 'off',
    'lines-between-class-members': [
      'error',
      'always',
      { exceptAfterSingleLine: true },
    ],

    // Typescript
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/no-var-requires': 'off',
    '@typescript-eslint/no-use-before-define': [
      'error',
      {
        functions: false,
        classes: true,
        variables: true,
        typedefs: true,
      },
    ],
    '@typescript-eslint/no-unused-vars': [
      'error',
      { ignoreRestSiblings: true, argsIgnorePattern: '^_' },
    ],
    '@typescript-eslint/naming-convention': 'off',
  },
}
