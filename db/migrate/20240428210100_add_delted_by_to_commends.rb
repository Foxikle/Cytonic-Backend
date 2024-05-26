class AddDeltedByToCommends < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :deleted_by, :integer # ID of the user who deleted the comment
  end
end
