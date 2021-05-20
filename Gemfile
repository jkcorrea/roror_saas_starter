source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.6.5"

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 6.0.1"
# Use postgresql as the database for Active Record
gem "pg", "~> 0.21"
# Use Puma as the app server
gem "puma", "~> 4.3"
gem "rack-timeout"
# Use SCSS for stylesheets
gem "sass-rails", ">= 6"
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
# gem "webpacker", "~> 4.0"
gem "webpacker", git: "https://github.com/rails/webpacker"
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem "turbolinks", "~> 5"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem "jbuilder", "~> 2.7"
# Use Redis adapter to run Action Cable in production
gem "redis", "~> 4.0"
# Use Redis Rails to set up a Redis backed Cache and / or Session
# gem "redis-rails", "~> 5.0"
# Use Active Model has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Pretty html abstractions
gem "slim", "~> 4.1"
gem "haml", "~> 5"
gem "simple_form", "~> 5"

gem 'mini_racer', platforms: :ruby
gem "react_on_rails", "~> 12.0"

# Multi-tennancy
gem "ros-apartment", require: "apartment" # TODO this is a temp fork
gem "ros-apartment-sidekiq", require: "apartment-sidekiq" # TODO this is a temp fork
# gem "apartment", "~> 2.2"
# gem "apartment-sidekiq", "~> 1.2"

# Authentication
gem "devise", "~> 4"
gem "devise_invitable", "~> 2.0"
# Authorization
gem "pundit", "~> 2.1"

# Soft deletes for ActiveRecord done right
gem "discard", "~> 1.2"

# Pretty admin dashboards
gem "administrate", "~> 0.13"

gem "receipts", "~> 1.0"
# Stripe stuff
gem "stripe", "~> 5.22"
gem "stripe_event", "~> 2.3.1"

# Upload to S3 directly
gem "aws-sdk-s3", "~> 1.75"

# Use Active Storage variant
gem "image_processing", "~> 1.2"

# Impersonate other users
gem "pretender"

# Search
# gem "searchkick", "~> 3.0"

# Jerbs
gem "sidekiq", "~> 5.0"

# Use Clockwork or Whenever for recurring background tasks
# gem "clockwork"
# gem "whenever"

# Feature flagging
gem "flipper"
gem "flipper-redis"
gem "flipper-ui"

gem "counter_culture", "~> 1.11"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.4.2", require: false

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.15"
  gem "webdrivers"
  gem "factory_bot_rails", "~> 4.8"
  gem "pry"
  gem "rails-controller-testing", "~> 1"
  gem "rspec-rails", "~> 3.6"
  gem "selenium-webdriver"
  gem "stripe-ruby-mock", github: "archonic/stripe-ruby-mock", require: "stripe_mock"
  gem "dotenv-rails"
end

group :development do
  gem "slim_lint", require: false
  gem "haml-lint", require: false
  gem "rubocop"
  gem "rubocop-rspec", require: false
  gem 'annotate'

  # Access an interactive console on exception pages or by calling "console" anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

group :test do
  gem "database_cleaner", "~> 1.6"
  gem "faker", "~> 1.8"
  gem "shoulda-matchers", "~> 3.1"
  gem "simplecov", require: false
end

gem "tzinfo-data"
