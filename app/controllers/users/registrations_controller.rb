class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_params
  include RackSessionsFix
  respond_to :json

  def destroy
    resource.destroy
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    render json: {
      message: 'User successfully terminated.'
    }, status: :ok
  end

  # def update
  #   # self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
  #   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
  #
  #   puts resource
  #   puts account_update_params
  #
  #   resource_updated = update_resource(resource, account_update_params)
  #   yield resource if block_given?
  #   if resource_updated
  #     set_flash_message_for_update(resource, prev_unconfirmed_email)
  #     bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
  #
  #     respond_with resource, location: after_update_path_for(resource)
  #   else
  #     clean_up_passwords resource
  #     set_minimum_password_length
  #     respond_with resource
  #   end
  # end
  def update
    @user = User.find(current_user.id)

      if @user.update_with_password(password_params)
        render json: "User password successfully changed.", status: :ok
      else
         render json: @user.errors, status: :unprocessable_entity
      end
  end


  def account_update_params
    devise_parameter_sanitizer.sanitize(:change_password)
  end

  def configure_params
    devise_parameter_sanitizer.permit(:change_password, keys: [:password, :password_confirmation, :current_password])
  end

  private
  def password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        status: {code: 200, message: 'Signed up successfully.'},
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        status: {message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
  end
end