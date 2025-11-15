require "active_support/core_ext/integer/time"
all_mailer_configs = Rails.application.config_for(:mailers)


Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Disable serving static files from `public/`, relying on NGINX/Apache to do so instead.
  config.public_file_server.enabled = true

  # Do not fall back to assets pipeline if a precompiled asset is missed.
  config.assets.compile = true

  config.assets.gzip = false

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Store uploaded files on the local file system (see config/storage.yml for options).
  # Use MinIO (S3-compatible) storage if credentials are provided
  s3_access_key = ENV.fetch('S3_ACCESS_KEY_ID', '')
  s3_secret_key = ENV.fetch('S3_SECRET_ACCESS_KEY', '')
  s3_bucket = ENV.fetch('S3_BUCKET', '')
  s3_endpoint = ENV.fetch('S3_ENDPOINT', '')

  # Try to use S3/MinIO if credentials are provided and gem is available
  if s3_access_key.present? && s3_secret_key.present? && s3_bucket.present? && s3_endpoint.present?
    begin
      require 'aws-sdk-s3'
      config.active_storage.service = :s3
      Rails.logger&.info "Using MinIO/S3 storage: #{s3_endpoint}"
    rescue LoadError => e
      config.active_storage.service = :local
      Rails.logger&.warn "aws-sdk-s3 gem not available, using local storage: #{e.message}"
    end
  else
    config.active_storage.service = :local
    Rails.logger&.info "Using local storage (S3 credentials not fully configured)"
  end

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = false

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true
  config.ssl_options = { redirect: { exclude: -> request {
    request.path == "/api/internal/domain/verify" ||
      request.path == "/api/internal/analytics/user" } } }

  # Skip http-to-https redirect for the default health check endpoint.
  # config.ssl_options = { redirect: { exclude: ->(request) { request.path == "/up" } } }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [:request_id]
  config.logger = ActiveSupport::TaggedLogging.logger(STDOUT)

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  config.active_job.queue_adapter = :sidekiq
  
  # Konfiguracja Sidekiq z Redis
  redis_url = ENV.fetch('REDIS_URL', 'redis://redis:6379/0')
  Sidekiq.configure_server do |config|
    config.redis = { url: redis_url }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: redis_url }
  end

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Set host to be used by links generated in mailer templates.
  fronted_url = ENV.fetch('FRONTEND_URL', Rails.application.credentials.dig(Rails.env.to_sym, :frontend_url)) || 'http://localhost:3000'
  config.action_mailer.default_url_options = { host: fronted_url }

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  # config.action_mailer.smtp_settings = {
  #   user_name: Rails.application.credentials.dig(:smtp, :user_name),
  #   password: Rails.application.credentials.dig(:smtp, :password),
  #   address: "smtp.example.com",
  #   port: 587,
  #   authentication: :plain
  # }

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [:id]

  config.hosts = nil
  if fronted_url.present?
    parsed_url = URI.parse(fronted_url)
    Rails.application.routes.default_url_options = { 
      host: parsed_url.host,
      protocol: parsed_url.scheme || 'https'
    }
    config.action_controller.asset_host = fronted_url
    # Ustaw domyślny protokół dla Active Storage URL-i
    config.active_storage.resolve_model_to_route = :rails_storage_proxy
  end

  smtp_enabled = ENV.fetch('SMTP_MAIL_ADDRESS', Rails.application.credentials.dig(Rails.env.to_sym, :smtp_mail, :address)).present?
  if smtp_enabled
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = all_mailer_configs[:smtp][:smtp_settings]
  else
    config.action_mailer.delivery_method = :test
  end
end
