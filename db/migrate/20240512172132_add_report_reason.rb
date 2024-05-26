class AddReportReason < ActiveRecord::Migration[7.1]
  def change
    add_column :comment_reports, :reason, :string, null: false, default: "UNKOWN"
  end
end
