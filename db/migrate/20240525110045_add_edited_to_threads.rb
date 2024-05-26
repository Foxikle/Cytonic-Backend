class AddEditedToThreads < ActiveRecord::Migration[7.1]
  def change
    add_column :threads, :edited, :boolean
    add_column :threads, :edited_at, :datetime
  end
end
