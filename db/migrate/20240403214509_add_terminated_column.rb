class AddTerminatedColumn < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :terminated, :boolean, default: false
  end
end
