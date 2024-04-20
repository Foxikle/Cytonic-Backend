class AddTerminationDateAndReason < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :termination_date, :datetime
    add_column :users, :termination_reason, :text
  end
end
