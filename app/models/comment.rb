class Comment < ApplicationRecord
  belongs_to :thread, :class_name => 'Forums::Thread'
  belongs_to :user, :class_name => 'User'
  has_many :comment_versions, :class_name => 'CommentVersion', :dependent => :nullify

  # Before updating a comment, save the current version to comment_versions
  before_update :save_version

  private

  def save_version
    # Create a new comment version with the current content and edited_at timestamp
    CommentVersion.create(
      user_id: user_id,      # ID of the user who created the comment
      body: body,            # Content of the comment before updating
      edited_at: updated_at  # The timestamp when the comment was last edited
    )
  end
end
