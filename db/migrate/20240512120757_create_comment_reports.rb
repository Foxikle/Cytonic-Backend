class CreateCommentReports < ActiveRecord::Migration[7.1]
  def change
    create_table :comment_reports do |t|
      t.references :comment, null: false, foreign_key: false
      t.references :user, null: false, foreign_key: { to_table: :users }
      t.datetime :resolved_at, null: false
      t.boolean :resolved, null: false, default: false
      t.text :action, null: false
      t.references :resolving_user, null: true, foreign_key: { to_table: :users }
      t.timestamps
      t.index [:resolved], unique: true, name: 'resolved_index'
    end
  end
end
