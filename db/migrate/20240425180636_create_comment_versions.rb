class CreateCommentVersions < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_versions do |t|
      t.references :comment, null: false, foreign_key: true # The original comment
      t.references :user, null: false, foreign_key: true # The user who made the edit
      t.text :body # The content of the comment
      t.timestamp :edited_at # When the edit was made

      t.timestamps
    end
  end
end
