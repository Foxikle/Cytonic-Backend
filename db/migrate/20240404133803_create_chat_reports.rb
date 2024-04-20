class CreateChatReports < ActiveRecord::Migration[7.1]
  def change
    create_table :chat_reports do |t|

      # UUID of reported user
      t.string :uuid, null: false
      t.string :reason, default: ""
      t.text :history

      # Reporter
      t.string :reporter_uuid

      t.integer :id

      t.timestamps
    end
  end
end
