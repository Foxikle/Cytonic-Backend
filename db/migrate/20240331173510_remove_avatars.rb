class RemoveAvatars < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :avatar
  end
end
