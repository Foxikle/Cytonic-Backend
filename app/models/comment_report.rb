class CommentReport < ApplicationRecord
  belongs_to :comment # the comment in question
  belongs_to :user, class_name: 'User', foreign_key: 'user_id' # the user who reported the comment
  belongs_to :user, class_name: 'User', foreign_key: 'resolving_user_id', optional: true # the user who resolved the reported comment
end
