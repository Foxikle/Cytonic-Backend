# frozen_string_literal: true

class Auth::PasswordsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])
    if user
      user.send_reset_password_instructions
      render json: { success: true }, status: :ok
    end
  end

  # GET /auth/passwords?reset_token=abcdef
  def index
    host = 'https://cytonic.net' #'http://localhost:5173'
    token = params[:reset_token].to_s
    id = params[:id].to_s

    unless token
      redirect_to host + "/auth/password-reset?redirect=invalid_link", status: 302, allow_other_host: true
      return
    end
    unless id
      redirect_to host + "/auth/password-reset?redirect=invalid_link", status: 302, allow_other_host: true
      return
    end

    user = User.find(id)
    unless user
      redirect_to host + "/auth/password-reset?redirect=invalid_link", status: 302, allow_other_host: true
      return
    end

    unless user.reset_password_sent_at || user.reset_password_token
      redirect_to host + "/auth/password-reset?redirect=already_changed", status: 302, allow_other_host: true
      return
    end

    if user.reset_password_sent_at < 2.hours.ago
      redirect_to host + "/auth/password-reset?redirect=expired_token", status: 302, allow_other_host: true
      return
    end

    if user.reset_password_token != Devise.token_generator.digest(self, :reset_password_token, token)
      redirect_to host + "/auth/password-reset?redirect=wrong_token", status: 302, allow_other_host: true
      return
    end

    redirect_to host + "/auth/password-reset?reset_token=" + token + "&id=" + id, status: 302, allow_other_host: true
  end

  def update
    user = User.with_reset_password_token(params[:reset_password_token])

    if user&.reset_password_period_valid?
      if user.reset_password(params[:password], params[:password_confirmation])
        render json: { message: 'Password has been successfully reset.' }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Invalid or expired token.' }, status: :unprocessable_entity
    end
  end
end
