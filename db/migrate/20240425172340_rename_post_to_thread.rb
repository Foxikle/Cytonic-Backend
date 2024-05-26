class RenamePostToThread < ActiveRecord::Migration[7.1]
  def change
    rename_table :posts, :threads
  end
end
