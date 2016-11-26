class ApplicationController < ActionController::Base
  # before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # alternative to overriding exceptions
  if Rails.env.production?
    rescue_from "Exception", with: :forbidden
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  def after_sign_in_path_for(resource)
    authenticate_user(current_user) # Signal to ActionCable who we are
    stored_location_for(resource) || '/'
  end

  private

  def ensure_authenticated_user
    authenticate_user(cookies.signed[:user_id]) || redirect_to(new_session_url)
  end

  def authenticate_user(current_user)
    if authenticated_user = User.find_by(id: current_user.id)
      cookies.signed[:user_id] ||= current_user.id
      #@current_user = authenticated_user
    end
  end

  def unauthenticate_user
    ActionCable.server.disconnect(current_user: current_user)
    #@current_user = nil
    cookies.delete(:user_id)
  end

  def forbidden(exception)
    render text: exception.message
  end

  protected

  # def configure_permitted_parameters
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  # end
end
