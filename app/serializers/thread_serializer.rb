class ThreadSerializer
  include JSONAPI::Serializer


  attributes :id, :private, :title, :body, :user, :topic, :category, :created_at, :updated_at, :deleted, :deleted_at, :edited, :deleted_at, :locked, :locked_at

  belongs_to :user, serializer: UserSerializer

  has_many :comments, attributes: [:created_at, :updated_at, :body, :edited, :deleted_at, :deleted_by, :deleted], serializer: CommentSerializer do |serializer, params|
    if params[:current_user]&.moderator?
      serializer.comments.select { true }
    else
      # Remove deleted comments unless current_user is a moderator
      serializer.comments.reject(&:deleted)
    end
  end

end
