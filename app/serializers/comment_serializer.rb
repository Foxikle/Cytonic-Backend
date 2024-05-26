class CommentSerializer
  include JSONAPI::Serializer

  attributes :created_at, :updated_at, :body, :edited, :deleted_at, :deleted_by, :deleted  # Fields to include in serialization

  attribute :user do |comment|
    SafeUserSerializer.new(comment.user).serializable_hash
  end

  belongs_to :user, serializer: UserSerializer
end

