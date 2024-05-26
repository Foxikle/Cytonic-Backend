class Forums::CommentsController < ApplicationController

  # DELETE /forums/comments/:id
  def destroy # NOTE: This is a SOFT delete
    unless current_user
      render json: { error: "You must be logged in to delete comments" }, status: :unauthorized
      return
    end

    @comment = Comment.find(params[:id])

    unless can_delete? @comment
      render json: { error: "You do not have permission to delete this comment" }, status: :forbidden
      return
    end

    @comment.update_attribute(:deleted_at, DateTime.now)
    @comment.update_attribute(:deleted_by, current_user.id)
    @comment.update_attribute(:deleted, true)

    render json: { success: "Comment deleted" }, status: :ok
  end

  # PUT /forums/comments/:thread_id
  def create
    unless current_user
      render json: { error: 'You must be logged in to create a comment' }, status: :unauthorized
      return
    end

    if current_user.muted == true
      render json: { error: 'You are muted and cannot make comments' }, status: :forbidden
      return
    end

    user = current_user
    thread_id = params[:thread_id]
    text = params[:body]

    unless text || text.empty?
      render json: { error: 'You must provide a comment body' }, status: :bad_request
      return
    end
    unless text.empty?
      render json: { error: 'You must provide a comment body' }, status: :bad_request
      return
    end
    unless thread_id
      render json: { error: 'You must provide a thread' }, status: :bad_request
      return
    end

    unless Forums::Thread.exists?(thread_id)
      render json: { error: 'Thread does not exist' }, status: :bad_request
      return
    end

    if Forums::Thread.find(thread_id).locked
      render json: { error: 'Thread is locked' }, status: :bad_request
      return
    end

    @comment = Comment.new(user: user, thread: Forums::Thread.find(thread_id), body: text, edited: false)

    if @comment.save
      render json: CommentSerializer.new(@comment).serializable_hash, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH /forums/comments/:id
  def update
    unless current_user
      render json: { error: 'You must be logged in to edit a comment' }, status: :unauthorized
      return
    end

    @comment = Comment.find(params[:id])

    unless @comment
      render json: { error: 'Comment not found' }, status: :not_found
      return
    end

    unless @comment.user == current_user
      render json: { error: 'You do not have permission to edit this comment' }, status: :forbidden
      return
    end

    @comment.update(body: params[:body])
    @comment.update(edited: true)

    if @comment.save
      render json: CommentSerializer.new(@comment).serializable_hash, status: :ok
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # GET /forums/comments/:id
  def show
    @comment = Comment.find(params[:id])

    if @comment.deleted?
      render json: { error: 'Comment not found' }, status: :not_found
      return
    end

    render json: CommentSerializer.new(@comment).serializable_hash, status: :ok
  end

  # GET /forums/comments/:thread_id
  def index
    unless params[:thread_id]
      render json: { error: 'You must provide a thread' }, status: :bad_request
      return
    end

    @comments = Comment.where(thread_id: params[:thread_id], deleted: false)
    puts comments

    render json: CommentSerializer.new(@comments).serializable_hash, status: :ok
  end


  private

  def can_delete?(comment)
    comment.user == current_user || current_user.moderator?
  end

end
