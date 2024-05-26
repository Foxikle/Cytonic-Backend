class Fix < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comment_reports, :action, false
    change_column_null :comment_reports, :resolved_at, false
  end
end
