class ApplicationController < ActionController::Base

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
     def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:email, :fullname, :username, :password, :display_picture)}
        devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:email, :fullname, :username, :bio, :gender)}
     end
end
