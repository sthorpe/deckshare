# cable/config.ru
require_relative '../config/environment'
Rails.application.eager_load!

ActionCable.server.config.allowed_request_origins = ['https://dogo-staging.herokuapp.com', 'http://localhost:3000']

run ActionCable.server
