class Fix3 < ActiveRecord::Migration[7.1]
  def change
    remove_index :comment_reports, :resolved, unique: false
  end
end
