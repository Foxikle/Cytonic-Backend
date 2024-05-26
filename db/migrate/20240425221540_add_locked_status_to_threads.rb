class AddLockedStatusToThreads < ActiveRecord::Migration[7.1]
  def change
    add_column :threads, :locked_at, :datetime
    add_column :threads, :locked, :boolean
  end
end
