class Fix2 < ActiveRecord::Migration[7.1]
  def change
    change_column_null :comment_reports, :action, true
    change_column_null :comment_reports, :resolved_at, true
  end
end
