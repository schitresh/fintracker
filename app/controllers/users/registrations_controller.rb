class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %w[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %w[first_name last_name])
  end
end