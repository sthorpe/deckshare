class HomeController < ApplicationController
  layout 'signup_layout', :only => [:signup]

  def index
    if user_signed_in?
      redirect_to '/decks'
    end
  end

  def signup
    @param = (0...8).map { (65 + rand(26)).chr }.join
  end

  def save_email
    if request.post?
      @newsletter = Newsletter.new(params[:email])
      @newsletter.save
    end
  end
end
