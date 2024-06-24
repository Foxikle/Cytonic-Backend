class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    self.resource = resource_class.new
  end

  # POST /resource/confirmation
  def create
    user = User.find(params[:id])

    if user
      if user.confirmed?
        render json: { message: 'Account is already confirmed.' }, status: 200
      else
        user.send_confirmation_instructions
        render json: { message: 'Confirmation email has been resent.' }, status: 200
      end
    end

  rescue ActiveRecord::RecordNotFound
    user = User.find_by(email: params[:id])
    if user
      if user.confirmed?
        render json: { message: 'Account is already confirmed.' }, status: 200
      else
        user.send_confirmation_instructions
        render json: { message: 'Confirmation email has been resent.' }, status: 200
      end
    else
      render json: { error: 'User not found.' }, status: 404
    end

    # self.resource = resource_class.send_confirmation_instructions(resource_params)
    # yield resource if block_given?
    #
    # if successfully_sent?(resource)
    #   render json: {
    #     status: 200,
    #     message: 'Email Sent'
    #   }, status: :ok
    #   # respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    # else
    #   render json: {
    #     status: 500,
    #     message: 'Internal Server Error :('
    #   }, status: 500
    #   # respond_with(resource)
    # end
  end

  # GET /confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      # render json: {message: "Success! Your account has been verified!", status: 200}, status: :ok
      redirect_to "https://cytonic.net/auth/login?redirect=confirmed_email", status: 302, allow_other_host: true
    else
      redirect_to "https://cytonic.net/auth/login?redirect=invalid_link", status: 302, allow_other_host: true
    end
  end
end
