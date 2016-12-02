require 'resolv-replace'
# Disable Sidekiq logging
Sidekiq::Logging.logger = nil

# Writes to default Redis DB - 0

redis_url = ENV['REDIS_PROVIDER'] || 'redis://redistogo:bb67e1cd2cc992eecfeb5454416ce52a@crestfish.redistogo.com:9797/'

Sidekiq.configure_client do |config|
  config.redis = { url: redis_url }

  # config.client_middleware do |chain|
  #   chain.add Sidekiq::Middleware::Whodunit::Client
  # end
end

Sidekiq.configure_server do |config|
  config.redis = { url: redis_url }

  sidekiq_db_pool = 8

  # if (database_url = ENV['DATABASE_URL']).present?
  #   ENV['DATABASE_URL'] = "#{database_url}?pool=#{sidekiq_db_pool}"
  #   ActiveRecord::Base.establish_connection
  # end

  config.average_scheduled_poll_interval = 1

  # config.server_middleware do |chain|
  #   chain.add Sidekiq::Middleware::Whodunit::Server
  # end
  #
  # config.client_middleware do |chain|
  #   chain.add Sidekiq::Middleware::Whodunit::Client
  # end
end

require 'sidekiq/web'
# Sidekiq::Web.use Rack::Auth::Basic do |username, password|
#   username == Settings.sidekiq.admin_user && password == Settings.sidekiq.admin_password
# end if %w(staging production).include?(Rails.env)

# Skip delayed emails in test env
Sidekiq::Mailer.excluded_environments = [:development, :test]
