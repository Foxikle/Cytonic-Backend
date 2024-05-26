class CommentReportSerializer
  include JSONAPI::Serializer
  attributes :resolved, :resolved_at, :created_at, :updated_at, :action, :reason, :user

  attribute :comment do |report|
    CommentSerializer.new(report.comment).serializable_hash
  end

  # has stuff
  belongs_to :comment, serializer: CommentSerializer # the comment in question
  belongs_to :user, class_name: 'User', foreign_key: 'user_id', serializer: SafeUserSerializer, attributes: [:id, :name, :role, :avatar_url] # the user who reported the comment
  belongs_to :resolving_user, class_name: 'User', foreign_key: 'resolving_user_id', optional: true, serializer: SafeUserSerializer, attributes: [:id, :name, :role, :avatar_url]  # the user who resolved the reported comment

end
