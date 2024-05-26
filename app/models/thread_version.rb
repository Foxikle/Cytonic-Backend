class ThreadVersion < ApplicationRecord
  belongs_to :forums_thread, :class_name => 'Forums::Thread'
  belongs_to :user

  # Validations (optional but recommended)
  validates :thread_id, presence: true
  validates :user_id, presence: true
  validates :body, presence: true
end
