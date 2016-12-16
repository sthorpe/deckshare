require "facebook/messenger"
include Facebook::Messenger
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
  Bot.deliver({
    recipient: {
      id: '45123'
    },
    message: {
      text: 'Hello, world'
    }
  }, access_token: 'EAADRoZCKkBjoBAAADzh8MzWYuI1tyQNrxYd81cDZCIHWWGWqUx1LGOBgyb880tPMdQWF1KZB3fVJMpMLbnWYgMos43EJRHxKDCistFxuBSYYDzd1IcR9q5lRzL6ZBcOfcJk3U4ZCZClVcDz4hKZBWPn5ZA58lDXCemiycRUV6tF1jgZDZD')
end
