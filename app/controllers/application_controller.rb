class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # NOTE: You can override the default behaviour by creating an after_sign_in_path_for [RDoc] method in your ApplicationController and have it return the path for the page you want:

  def after_sign_in_path_for(resource_or_scope)
    current_user # redirects to a user's show page
  end

  # NOTE: For use with OAuth
  # def after_sign_in_path_for(resource)
  #   request.env['omniauth.origin'] || root_path
  # end


  # NOTE: Adding new paramters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :age])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :age])
  end

end
