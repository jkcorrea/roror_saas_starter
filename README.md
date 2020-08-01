# MantleDB

## Quick Start

Update `.env`:

```sh
cp .env.example .env
# Modify as needed
```

Install dependencies:

```sh
yarn install
bundle install

gem install foreman # Used to run webpacker and rails, install it globally as shown here
```

Setup database:

```sh
rails db:setup
```

Run!

```sh
foreman start -f Procfile.dev-hmr # Disables SSR, enables HMR
# OR
foreman start -f Procfile.dev-ssr # Disables HMR, enabls SSR
```
