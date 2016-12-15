class WebhookController < ApplicationController
  include Facebook::Messenger

  def bot
    if request.post?
      raise "#{params.inspect}"
    else
      if params['hub.mode'] === 'subscribe' && params['hub.verify_token'] === 'my_dog_is_my_password_verify'
        puts 'Validating Webhook'
        render :json => "#{params["hub.challenge"]}"
      else
        Bugsnag.notify('There is a problem with the webhook url')
      end
    end
  end
end
