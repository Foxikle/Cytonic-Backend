class AddMutedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :muted, :boolean, default: false
    add_column :users, :muted_at, :datetime
    add_column :users, :muted_until, :datetime
  end
end
