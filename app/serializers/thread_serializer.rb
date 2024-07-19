class ThreadSerializer

  def initialize(thread, current_user)
    @thread = thread
    @current_user = current_user
  end

  def as_json(*)
    {
      id: @thread.id,
      private: @thread.private,
      title: @thread.title,
      body: @thread.body,
      topic: @thread.topic,
      category: @thread.category,
      created_at: @thread.created_at,
      updated_at: @thread.updated_at,
      deleted: @thread.deleted,
      edited: @thread.edited,
      locked: @thread.locked,
      user: SafeUserSerializer.new(@thread.user).as_json,
      comments: filtered_comments.map { |comment| CommentSerializer.new(comment).as_json }
    }
  end

  private

  def filtered_comments
    if @current_user&.moderator?
      @thread.comments
    else
      @thread.comments.reject(&:deleted)
    end
  end

end
