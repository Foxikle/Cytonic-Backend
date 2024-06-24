# frozen_string_literal: true

class Admin::AvatarsController < ApplicationController

  # DELETE /admin/avatars/:id
  def remove_avatar
    unless current_user
      render json: { error: 'Not logged in' }, status: :unauthorized
    end
    unless Role.can_moderate.include?(current_user.role)
      render json: { error: 'Not authorized' }, status: :forbidden
    end

    user = User.find_by(id: params[:id])
    unless user
      render json: { error: 'Avatar not found' }, status: :not_found
    end

    user.avatar_url = nil
    user.save!

    if user.avatar.attached?
      user.avatar.purge
      render json: { message: 'Successfully removed ' + user.name + '\'s avatar.' }, status: :ok
    else
      render json: { message: user.name + 'does not have an avatar to remove: ERR 1009' }, status: :unprocessable_entity
    end
  end
end
