class CommentSerializer

  def initialize(comment)
    @comment = comment
  end

  def as_json(*)
    {
      id: @comment.id,
      created_at: @comment.created_at,
      updated_at: @comment.updated_at,
      body: @comment.body,
      edited: @comment.edited,
      deleted_at: @comment.deleted_at,
      deleted_by: deleted_by,
      deleted: @comment.deleted,
      user: SafeUserSerializer.new(@comment.user).as_json
    }
  end

  private

  # Returns the user associated with deleting the comment
  def deleted_by
    if @comment.deleted
      SafeUserSerializer.new(User.find(@comment.deleted_by)).as_json
    else
      nil
    end
  end
end

