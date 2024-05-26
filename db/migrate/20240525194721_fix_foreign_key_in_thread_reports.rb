class FixForeignKeyInThreadReports < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :thread_reports, :threads
  end
end
