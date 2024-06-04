class Forums::Thread < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :nullify
  before_update :save_version


  def soft_delete
    self.deleted_at = DateTime.now
    self.deleted = true
    self.save
  end

  def lock_thread!
    self.locked = true
    self.locked_at = DateTime.now
    self.save
  end

  def unlock_thread!
    self.locked = false
    self.locked_at = nil
    self.save
  end

  # Define who can view a thread
  def show? (user)
    true unless thread_restricted? user
  end

  private

  def save_version
    # Create a new thread version with the current content and edited_at timestamp
    ThreadVersion.create(
      user_id: user_id,      # ID of the user who created the thread
      body: body,            # Content of the thread before updating
      edited_at: updated_at  # The timestamp when the thread was last edited
    )
  end

  def thread_restricted? (user)
    if user
      return false if unrestricted? user.role || self.user == user
    end

    restricted_categories = ["STAFF_CONTACT"]
    restricted_topics = %w[BUG_REPORTS PUNISHMENT_APPEALS]
    restricted_categories.include?(self.category) || restricted_topics.include?(self.topic) || self.deleted
  end

  def unrestricted?(role)
    case role
    when Role::OWNER, Role::ADMIN, Role::MODERATOR
      true
    else
      false
    end
  end
end
