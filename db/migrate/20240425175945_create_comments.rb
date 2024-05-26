class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true # The user that made the comment
      t.references :thread, null: false, foreign_key: true
      t.text :body
      t.boolean :edited

      t.timestamps
    end

    add_index :comments, :thread_id
    add_index :comments, :user_id
  end
end
