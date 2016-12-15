class WebhookController < ApplicationController

  def bot
    raise "#{params.inspect}"
    render :json => params.inspect
  end
end
