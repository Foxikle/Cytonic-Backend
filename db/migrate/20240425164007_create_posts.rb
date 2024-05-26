class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false  # Title of the thread
      t.index :title # Index for more efficient queries

      t.string :category, null: false
      t.index :category

      t.string :topic, null: false
      t.index :topic

      t.text :body, null: false     # Content of the thread
      t.references :user, null: false, foreign_key: true  # The author of the thread
      # t.index :user # Index for more efficient queries

      t.boolean :private, default: false # Only used for Punishment appeals and Bug Reports

      t.boolean :deleted, default: false # If the server shouldn't serve this thread (Soft delete)
      t.timestamp :deleted_at, default: nil
      t.index :deleted_at # Index for more efficient queries

      t.timestamps
    end
  end
end
