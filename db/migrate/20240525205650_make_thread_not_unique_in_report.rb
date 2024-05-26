class MakeThreadNotUniqueInReport < ActiveRecord::Migration[7.1]
  def change
    remove_index :thread_reports, :resolved, unique: false
  end
end
