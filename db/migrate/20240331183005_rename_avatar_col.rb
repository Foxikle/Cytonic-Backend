class RenameAvatarCol < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :avatar, :avatar_url
  end
end
