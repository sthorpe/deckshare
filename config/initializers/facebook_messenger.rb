require 'facebook/messenger'
include Facebook::Messenger
ENV['ACCESS_TOKEN'] = 'EAADRoZCKkBjoBABZCVZCH21vdZAdKCTxi9l6ZALW5HQRL0CaDxy20cJzFTe1EgAZARQDtmZCnZBMkZCqB9zsVsZAgXijmZCunDFZAiR9wK7TepZBU8WHWpc7OIgTF7vOcVI9jQKMyxVvA7UWmvwogdgZBPxfbn67YgcnKMPt8bWOaBZARMfHgZDZD'
ENV['APP_SECRET'] = 'abf011a5b7625b279efe686b2fb7d25b'
ENV['VERIFY_TOKEN'] = 'my_dog_is_my_password_verify'
# Facebook::Messenger.configure do |config|
#   config.access_token = 'EAADRoZCKkBjoBAAADzh8MzWYuI1tyQNrxYd81cDZCIHWWGWqUx1LGOBgyb880tPMdQWF1KZB3fVJMpMLbnWYgMos43EJRHxKDCistFxuBSYYDzd1IcR9q5lRzL6ZBcOfcJk3U4ZCZClVcDz4hKZBWPn5ZA58lDXCemiycRUV6tF1jgZDZD'
#   config.app_secret   = 'abf011a5b7625b279efe686b2fb7d25b'
#   config.verify_token = 'my_dog_is_my_password_verify'
# end
unless Rails.env.production?
  bot_files = Dir[Rails.root.join("app", "bot", "**", "*.rb")]
  bots_reloader = ActiveSupport::FileUpdateChecker.new(bot_files) do
    bot_files.each{ |file| require_dependency file }
  end
  ActionDispatch::Callbacks.to_prepare do
    bots_reloader.execute_if_updated
  end
  bot_files.each { |file| require_dependency file }
end
