class Users::UsernamesController < ApplicationController
  def update
    user = User.find(current_user.id)
    new_name = params[:user][:username]

    if user.update(name: new_name)
      render json: { message: "Username updated successfully" }, status: :ok
    else
      render json: { error: "Failed to update username" }, status: :unprocessable_entity
    end
  end
end
