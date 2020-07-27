module.exports = {
  trailingComma: 'all',
  tabWidth: 2,
  semi: false,
  singleQuote: true,
  printWidth: 80,
  overrides: [
    {
      files: '.editorconfig',
      options: { parser: 'yaml' },
    },
  ],
}
