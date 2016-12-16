require 'facebook/messenger'
include Facebook::Messenger
Facebook::Messenger.configure do |config|
  config.access_token = 'EAADRoZCKkBjoBAAADzh8MzWYuI1tyQNrxYd81cDZCIHWWGWqUx1LGOBgyb880tPMdQWF1KZB3fVJMpMLbnWYgMos43EJRHxKDCistFxuBSYYDzd1IcR9q5lRzL6ZBcOfcJk3U4ZCZClVcDz4hKZBWPn5ZA58lDXCemiycRUV6tF1jgZDZD'
  config.app_secret   = 'abf011a5b7625b279efe686b2fb7d25b'
  config.verify_token = 'my_dog_is_my_password_verify'
end
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

Facebook::Messenger::Subscriptions.subscribe
Bot.on :message do |message|
  Bot.deliver(
    recipient: message.sender,
    message: {
      text: message.text
    }
  )
end
Bot.on :optin do |optin|
Bot.deliver(
    recipient: optin.sender,
    message: {
      text: 'Ah, human!'
    }
  )
end
Bot.on :delivery do |delivery|
 puts "Human was online at #{delivery.at}"
end
Facebook::Messenger::Thread.set(
  setting_type: 'greeting',
  greeting: {
    text: 'Welcome to your new bot overlord!'
  }
)
