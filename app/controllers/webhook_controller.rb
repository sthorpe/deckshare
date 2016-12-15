class WebhookController < ApplicationController

  def bot
    render :json => "#{params["hub.challenge"]}"
  end
end
