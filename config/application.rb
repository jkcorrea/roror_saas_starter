require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MantleDB
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.log_level = ENV["LOG_LEVEL"]

    # Log to STDOUT because Docker expects all processes to log here. You could
    # then redirect logs to a third party service on your own such as systemd,
    # or a third party host such as Loggly, etc..
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.log_tags  = %i[subdomain uuid]
    config.logger    = ActiveSupport::TaggedLogging.new(logger)

    config.action_mailer.default_url_options = {
      host: ENV["ACTION_MAILER_HOST"]
    }
    config.action_mailer.default_options = {
      from: ENV["ACTION_MAILER_DEFAULT_FROM"]
    }

    # Set Redis as the back-end for the cache.
    config.cache_store = :redis_cache_store, { url: "#{ENV['REDIS_BASE_URL']}cache" }

    # Load/require custom ruby / rails extentions
    config.autoload_paths += Dir[Rails.root.join("lib", "core_ext", "*.rb")].each { |l| require l }
    config.autoload_paths += Dir[Rails.root.join("lib", "rails_ext", "*.rb")].each { |l| require l }

    # Set Sidekiq as the back-end for Active Job.
    config.active_job.queue_adapter = :sidekiq
    config.active_job.queue_name_prefix = "#{ENV['ACTIVE_JOB_QUEUE_PREFIX']}_#{Rails.env}"

    # Action Cable setting to de-couple it from the main Rails process.
    config.action_cable.url = ENV["ACTION_CABLE_FRONTEND_URL"]

    # Action Cable setting to allow connections from these domains.
    # origins = ENV["ACTION_CABLE_ALLOWED_REQUEST_ORIGINS"].split(",")
    # origins.map! { |url| /#{url}/ }
    # config.action_cable.allowed_request_origins = origins
    config.action_cable.mount_path = "/ws"
    config.action_cable.disable_request_forgery_protection = true
    # config.action_cable.allowed_request_origins = /http:\/\/localhost*/

  end
end
