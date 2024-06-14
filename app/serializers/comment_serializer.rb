class CommentSerializer
  include JSONAPI::Serializer

  attributes :created_at, :updated_at, :body, :edited, :deleted_at, :deleted # Fields to include in serialization

  attribute :user do |comment|
    SafeUserSerializer.new(comment.user).serializable_hash
  end

  attribute :deleted_by do |comment|
    if comment.deleted
      SafeUserSerializer.new(User.find(comment.deleted_by)).serializable_hash
    else
      nil
    end
  end

  belongs_to :user, serializer: UserSerializer
end

