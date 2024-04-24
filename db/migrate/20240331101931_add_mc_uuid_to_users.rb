class AddMcUuidToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :linked, :boolean
    add_column :users, :uuid, :string, default: nil
    add_index :users, :uuid, unique: true
  end
end
