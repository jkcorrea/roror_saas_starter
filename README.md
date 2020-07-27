# SaaS Starter

React on Ruby on Rails. Multi-tennant SaaS app with billing and some other niceties out-of-the-box :).

Based off [Limestone](https://github.com/archonic/limestone-accounts), updated to Rails 6 and using [React on Rails](https://github.com/shakacode/react_on_rails) for the frontend.

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
