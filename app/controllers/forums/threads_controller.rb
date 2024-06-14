class Forums::ThreadsController < ApplicationController

  # POST /forums/threads/
  def create
    unless current_user
      render json: { message: "You must be logged in to make a thread!" }, status: :unauthorized
      return
    end

    if current_user.muted == true
      render json: { message: "You are muted and cannot make threads!" }, status: :unauthorized
      return
    end

    params.require(:thread).permit(:title, :body, :category, :topic)
    user = current_user
    topic = Forums::Topic.find(params[:thread][:topic])
    category = Forums::Category.find(params[:thread][:category])
    title = params[:thread][:title]
    body = params[:thread][:body]

    if category == Forums::Category::NONE
      render json: { message: "The category " + params[:thread][:category].to_s + " doesn't exist!" }, status: :bad_request
      return
    end
    if topic == Forums::Topic::NONE
      render json: { message: "The topic " + params[:thread][:topic].to_s + " doesn't exist!" }, status: :bad_request
      return
    end

    unless Forums::Category.is_allowed_to_make?(user.role).include?(category)
      render json: { message: "You cannot make threads in the " + params[:thread][:category].to_s + " category!", code: "ERR_UNAUTHORIZED_CATEGORY" }, status: :unauthorized
      return
    end

    unless Forums::Topic.is_allowed_to_make?(user.role).include?(topic)
      render json: { message: "You cannot make threads in the " + params[:thread][:topic].to_s + " topic!", code: "ERR_UNAUTHORIZED_TOPIC" }, status: :unauthorized
      return
    end

    @thread = Forums::Thread.new(user: user, topic: topic.id, category: category.id, title: title, body: body)
    @thread.private = Forums::Topic.is_private? topic

    if @thread.save
      render json: { message: "Successfully created thread " + @thread.id.to_s + "!", threadData: ThreadSerializer.new(@thread, include: [:comments]).serializable_hash }, status: :created
    else
      render json: { message: "Failed to create thread." }, status: :internal_server_error
    end

  end

  # GET /forums/threads/:id
  def show
    # Find the thread by its ID from the URL parameter
    @thread = Forums::Thread.find(params[:id])

    # Make sure the user is authenticated if they need to be
    if @thread.private || @thread.deleted
      unless current_user
        render json: { message: "This thread has restricted access." }, status: :unauthorized
        return
      end

      unless Forums::Topic.is_allowed_to_view?(current_user.role).include?(Forums::Topic.find(@thread.topic))
        render json: { message: "This thread has restricted access." }, status: :forbidden
        return
      end
    end

    options = {
      include: [:comments],
      params: { current_user: current_user }
    }

    # Serialize the thread into a JSON-compliant format
    serialized_thread = ThreadSerializer.new(@thread, options).serializable_hash

    # Return the serialized thread as a JSON response
    render json: serialized_thread
  rescue ActiveRecord::RecordNotFound
    # Handle case where the thread with the given ID doesn't exist
    render json: { message: "The requested thread was not found" }, status: :not_found
  end

  # GET /forums/threads
  def index
    # Base query to fetch all threads
    threads = Forums::Thread.all

    # Filter by `show?` method
    visible_threads = threads.select { |thread| thread.show?(current_user) }

    # Further filter by topic using Enumerable
    if params[:topic].present?
      visible_threads = visible_threads.select { |thread| thread.topic == params[:topic] }
    end

    visible_threads = visible_threads.select { |thread| thread.deleted != true }

    # Serialize and return the filtered threads
    serialized_threads = ThreadSerializer.new(visible_threads).serializable_hash

    render json: serialized_threads, status: :ok

  rescue StandardError => e
    # Handle unexpected errors and return a server error status
    render json: { error: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

  # DELETE /forums/threads/:id
  def destroy
    unless current_user
      render json: { message: "You must be logged in to delete a thread." }, status: :unauthorized
    end

    @thread = Forums::Thread.find(params[:id])

    if current_user.id == @thread.user.id
      @thread.soft_delete
    elsif can_delete current_user.role
      @thread.soft_delete
    else
      render json: { message: "You cannot delete this thread." }, status: :forbidden
      return
    end

    # Respond with a success message
    render json: { message: "Thread successfully deleted." }, status: :ok
  rescue ActiveRecord::RecordNotFound
    # Handle case where the thread doesn't exist
    render json: { error: "The specified thread was not found." }, status: :not_found
  rescue StandardError => e
    # Handle unexpected errors
    render json: { error: "An error occurred while deleting the thread: #{e.message}" }, status: :internal_server_error
  end

  def update
    unless current_user
      render json: { error: 'You must be logged in to edit a thread' }, status: :unauthorized
      return
    end

    @thread = Forums::Thread.find(params[:id])

    unless @thread
      render json: { error: 'Comment not found' }, status: :not_found
      return
    end

    unless @thread.user == current_user
      render json: { error: 'You do not have permission to edit this thread' }, status: :forbidden
      return
    end

    @thread.update(body: params[:body])
    @thread.update(edited: true)
    @thread.update(edited_at: DateTime.now)

    if @thread.save
      render json: ThreadSerializer.new(@thread).serializable_hash, status: :ok
    else
      render json: @thread.errors, status: :unprocessable_entity
    end
  end

  private

  def can_delete(role)
    case role
    when Role::OWNER, Role::ADMIN, Role::MODERATOR
      true
    else
      false
    end
  end

  def unrestricted?(role)
    case role
    when Role::OWNER, Role::ADMIN, Role::MODERATOR
      true
    else
      false
    end
  end

  def are_compatible?(category, topic)
    case category
    when Forums::Category::OFFICIAL_COMMUNICATIONS
      (topic == Forums::Topic::NEWS_AND_ANNOUCEMENTS || topic == Forums::Topic::DEVLOGS)
    when Forums::Category::STAFF_CONTACT
      (topic == Forums::Topic::BUG_REPORTS || topic == Forums::Topic::PUNISHMENT_APPEALS)
    when Forums::Category::GAMES
      (topic == Forums::Topic::GILDED_GORGE)
    else
      false
    end
  end
end