bundle exec puma -C config/puma.rb -b tcp://127.0.0.1
client: sh -c 'rm app/assets/webpack/* || true && cd client && npm run build:development'
worker: bundle exec sidekiq -c 2
