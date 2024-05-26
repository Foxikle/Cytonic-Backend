class ApplicationController < ActionController::API

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :force_json

  protected
  def configure_permitted_parameters
    # Passwords
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name avatar])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name avatar])
  end

  def force_json
    request.format = :json
  end
end
