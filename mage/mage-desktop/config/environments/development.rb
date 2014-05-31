MageDesktop::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # roar/representable
  config.representer.default_url_options = { host: '127.0.0.1:3000' }

  # logging
  config.logger = ActiveSupport::Logger.new(STDOUT)
  config.logger.level = ActiveSupport::Logger.const_get(
    ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'].upcase : 'DEBUG'
  )

  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Livereload for maximum fun :-)
  config.middleware.use Rack::LiveReload, {
    live_reload_port: 3333,
    host: 'mage.dev',
    no_swf: true
  }

end
