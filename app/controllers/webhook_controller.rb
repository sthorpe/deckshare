class WebhookController < ApplicationController

  def bot
    render :json => params.inspect
  end
end
