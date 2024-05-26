class Forums::LockController < ApplicationController

  # POST /forums/lock/:thread_id
  def create
    unless current_user
      render json: { message: 'Not logged in' }, status: :unauthorized
      return
    end
    unless current_user.moderator?
      render json: { message: 'Unauthorized' }, status: :forbidden
      return
    end
    @thread = Forums::Thread.find(params[:id])
    @thread.lock_thread!

    render json: { message: 'Locked' }, status: :ok
  end

  def destroy
    unless current_user
      render json: { message: 'Not logged in' }, status: :unauthorized
      return
    end
    unless current_user.moderator?
      render json: { message: 'Unauthorized' }, status: :forbidden
      return
    end
    @thread = Forums::Thread.find(params[:id])
    @thread.unlock_thread!
  end
end
