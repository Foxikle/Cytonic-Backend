# frozen_string_literal: true

class Admin::UsersController < ApplicationController
  def list_users
    if current_user == nil
      render json: { message: "You do not have access to this." }, status: :unauthorized
      return
    end
    if is_allowed? User.find(current_user.id).role
      # User can see/list all users
      render json: {
        message: "Successfully fetched all users.",
        data: User.all
      }, status: :ok
    else
      render json: { message: "You do not have access to this." }, status: :unauthorized
    end
  end

  # DELETE /admins/user
  def terminate_user
    params.require(:target).permit(:id, :reason)
    admin = User.find(current_user.id)

    if is_allowed_admin? admin.role
      target_id = params[:target][:id]
      reason = params[:target][:reason]

      if target_id == admin.id
        render json: { message: "You cannot terminate yourself!" }, status: :unprocessable_entity
        return
      end

      target = User.find(target_id.to_i)

      if Role.power_over(admin.role).include? Role.value_of(target.role)
        target.update(terminated: true)
        target.update(termination_date: DateTime.now)
        target.update(termination_reason: reason)
        ApplicationMailer.with(user: target).termination_notice(target).deliver_later
        # Revoke token
        User.revoke_jwt(nil, target)
        render json: { message: target.name + "'s account was successfully terminated." }, status: :ok
        return
      else
        render json: { message: "You cannot terminate an account with more seniority over you!" }, status: :unauthorized
        return
      end
    else
      render json: { message: "You are not authorized to do this!" }, status: :unauthorized
    end
  end

  def restore_user
    params.require(:target).permit(:id)
    admin = User.find(current_user.id)

    if is_allowed_admin? admin.role
      target_id = params[:target][:id]

      if target_id == admin.id
        render json: { message: "You cannot restore yourself!" }, status: :unprocessable_entity
        return
      end

      target = User.find(target_id.to_i)

      if Role.power_over(admin.role).include? Role.value_of(target.role)
        target.update(terminated: false)
        ApplicationMailer.with(user: target).restoraion_notice(target).deliver_later
        # Revoke token
        User.revoke_jwt(nil, target)
        render json: { message: target.name + "'s account was successfully terminated." }, status: :ok
        return
      else
        render json: { message: "You are not authorized to do this!" }, status: :unauthorized
        return
      end
    else
      render json: { message: "You are not authorized to do this!" }, status: :unauthorized
    end
  end

  private
  def is_allowed?(role)
    valid_roles = [Role::OWNER, Role::ADMIN, Role::MODERATOR]
    valid_roles.include?(Role.value_of role)
  end

  def is_allowed_admin?(role)
    valid_roles = [Role::OWNER, Role::ADMIN]
    valid_roles.include?(Role.value_of role)
  end
end
