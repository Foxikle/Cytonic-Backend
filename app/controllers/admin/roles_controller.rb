class Admin::RolesController < ApplicationController

  def set_user_role
    admin = User.find(current_user.id)

    if Role.value_of admin.role == Role::ADMIN
      # todo: prevent demotions?
      target_id = params[:target][:id]

      if target_id == admin.id
        render json: {message: "You cannot change your own role!"}, status: :unprocessable_entity
        return
      end

      target = User.find(target_id.to_i)
      target_role = params[:target][:target_role]

      if Role.power_over(admin.role).include? Role.value_of(target.role)
        if is_valid_role? target_role.to_s
          target.update(role: target_role)
          render json: { message: target.name + "'s role was successfully set to " + target_role.to_s }, status: :ok
        else
          render json: { message: target_role.to_s + " is not a valid role!"}, status: :unprocessable_entity
        end
      else
        render json: { message: "You do now have power over " + target.name}, status: :unprocessable_entity
      end
    else
      render json: { message: "You are not authorized to do this!" }, status: :unauthorized
    end
  end

  def is_valid_role? (role)
    valid_roles = %w[admin moderator helper user]
    valid_roles.include?(role.downcase) # Check if the role is in the list of valid options (case insensitive)
  end
end
