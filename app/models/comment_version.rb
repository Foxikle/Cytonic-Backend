# frozen_string_literal: true

class CommentVersion < ApplicationRecord
  belongs_to :comment
  belongs_to :user

  # Validations (optional but recommended)
  validates :comment_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true
end
