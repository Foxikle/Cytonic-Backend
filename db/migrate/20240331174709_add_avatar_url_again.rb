class AddAvatarUrlAgain < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :avatar, :string, default: nil
  end
end
