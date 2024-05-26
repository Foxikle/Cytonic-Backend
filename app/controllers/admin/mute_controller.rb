# frozen_string_literal: true

class Admin::MuteController < ApplicationController

  # POST /admin/mute/:id
  def update
    unless current_user
      render json: { message: "Unauthorized." }, status: :unauthorized
      return
    end
    unless is_allowed?(current_user.role)
      render json: { message: "Forbidden." }, status: :forbidden
      return
    end

    @user = User.find(params[:id])

    days_muted = nil
    if @user.muted_at
      @user.update(muted_until: DateTime.now + 30.days)
      days_muted = 30
    else
      @user.update(muted_until: DateTime.now + 7.days)
      days_muted = 7
    end
    @user.update(muted: true)
    @user.update(muted_at: DateTime.now)
    render json: {message: "Successfully muted " + @user.name + " for " + days_muted.to_s + " days."}, status: :ok
  end

  # DELETE /admin/mute/:id
  def destroy
    unless current_user
      render json: { message: "Unauthorized." }, status: :unauthorized
      return
    end
    unless is_allowed?(current_user.role)
      render json: { message: "Forbidden." }, status: :forbidden
      return
    end

    @user = User.find(params[:id])
    @user.update(muted_until: DateTime.now - 1.seconds)
    @user.update(muted: false)

    render json: {message: "Successfully unmuted " + @user.name + "."}, status: :ok
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
