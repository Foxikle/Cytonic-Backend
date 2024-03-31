# frozen_string_literal: true

class Admin::UsersController < ApplicationController

  def list_users
    # todo add filtering for certain roles, ranks, etc
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

  private

  def is_allowed? (role)
    valid_roles = %w[admin moderator]
    valid_roles.include?(role.downcase) # Check if the role is in the list of valid options (case insensitive)
  end

end
