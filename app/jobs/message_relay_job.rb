class MessageRelayJob < ApplicationJob
  def perform(message)
    ActionCable.server.broadcast "messages:#{message.deck_id}",
      message: MessagesController.render(partial: 'messages/message', locals: { message: message, current_user: message.user })
  end
end
