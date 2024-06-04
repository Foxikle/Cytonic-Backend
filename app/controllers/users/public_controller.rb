# frozen_string_literal: true

class Users::PublicController < ApplicationController

  # GET /users/:id
  def show
    @user = User.find(params[:id])

    render json: SafeUserSerializer.new(@user).serializable_hash, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { message: "The requested user was not found" }, status: :not_found
  end
end
