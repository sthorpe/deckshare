class HomeController < ApplicationController
  layout 'signup_layout', :only => [:signup]

  def index
    if user_signed_in?
      redirect_to '/decks'
    end
  end

  def signup
  end
end
