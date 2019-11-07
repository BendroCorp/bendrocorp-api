class CreateBotReminders < ActiveRecord::Migration[5.1]
  def change
    create_table :bot_reminders, id: :uuid do |t|
      t.belongs_to :bot
      t.belongs_to :created_by
      t.text :message
      t.integer :recur_every, default: 0
      t.datetime :last_notification
      t.datetime :expires
      t.boolean :completed, default: false
      t.timestamps
    end
  end
end
