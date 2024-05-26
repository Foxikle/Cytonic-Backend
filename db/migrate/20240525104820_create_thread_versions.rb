class CreateThreadVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :thread_versions do |t|
      t.references :thread, null: false, foreign_key: true # The original thread
      t.references :user, null: false, foreign_key: true # The user who made the edit
      t.text :body # The content of the thread
      t.timestamp :edited_at # When the edit was made

      t.timestamps
    end
  end
end
