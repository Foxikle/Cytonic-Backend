class Users::SessionsController < Devise::SessionsController
  include RackSessionsFix
  respond_to :json

  def create
    puts "Hello!!!"
    self.resource = warden.authenticate!(auth_options)
    puts "Byeeee!!!"

    if User.find(resource.id).terminated
      render json: { message: "This user has been terminated for violating the Term of Service or User Conduct Agreement." }, status: :unauthorized
      User.revoke_jwt(nil, resource)
      return
    end
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def new
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
    else
      render json: {
        status: 401,
        message: "No active session."
      }, status: :unauthorized
      return
    end

    if current_user != nil
      if current_user.terminated
        render json: { message: "This user has been terminated for violating the Term of Service or User Conduct Agreement." }, status: :unauthorized
        return
      end
    end

    if User.jwt_revoked?(jwt_payload, current_user)
      render json: {
        status: 401,
        message: "No active session."
      }, status: :unauthorized
    else
      render json: {
        status: 200,
        message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }, status: :ok
    end
  end

  private
  def respond_with(current_user, _opts = {})
    render json: {
      status: {
        code: 200,
        message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }
    }, status: :ok
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].present?
      jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      current_user = User.find(jwt_payload['sub'])
      if !User.jwt_revoked?(jwt_payload, current_user)
        # If its not revoked, then revoke it.
        # User.revoke_jwt(jwt_payload, current_user)
        render json: {
          status: 200,
          message: 'Logged out successfully.'
        }, status: :ok
      else
        render json: {
          status: 401,
          message: "Invalid/expired Session."
        }, status: :unauthorized
      end
    else
      render json: {
        status: 400,
        message: "No Authentication Token Provided."
      }, status: :bad_request
    end
  end
end