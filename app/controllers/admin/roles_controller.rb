class Admin::RolesController < ApplicationController

  def set_user_role
    admin = User.find(current_user.id)

    if admin.role == "admin"
      # todo: prevent demotions?
      target_id = params[:target][:id]
      puts target_id
      target = User.find(target_id.to_i)

      puts target.name
      puts target.email

      target_role = params[:target][:target_role]
      puts target_role.to_s
      if is_valid_role? target_role.to_s
        target.update(role: target_role)
        render json: { message: target.name + "'s role was successfully set to " + target_role.to_s }, status: :ok
      else
        render json: { message: target_role.to_s + " is not a valid role!"}, status: :unprocessable_entity
      end
    else
      render json: { message: "You are not authorized to do this!" }, status: :unauthorized
    end
  end

  def is_valid_role? (role)
    valid_roles = %w[admin moderator user]
    valid_roles.include?(role.downcase) # Check if the role is in the list of valid options (case insensitive)
  end
end
