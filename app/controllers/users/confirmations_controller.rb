class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    self.resource = resource_class.new
  end

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      render json: {
        status: 200,
        message: 'Email Sent'
      }, status: :ok
      # respond_with({}, location: after_resending_confirmation_instructions_path_for(resource_name))
    else
      render json: {
        status: 500,
        message: 'Internal Server Error'
      }, status: 500
      # respond_with(resource)
    end
  end

  # GET /confirmation?confirmation_token=abcdef
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      # render json: {message: "Success! Your account has been verified!", status: 200}, status: :ok
      redirect_to "http://localhost:5173/auth/login?redirect=confirmed_email", status: 302
    else
      redirect_to "http://localhost:5173/auth/login?redirect=invalid_link", status: 302
    end
  end
end
