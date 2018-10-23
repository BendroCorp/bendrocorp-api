class CreateUserSettings < ActiveRecord::Migration[5.1]
  def change
    create_table :user_settings do |t|
      t.boolean :notify_for_new_messages, default: true
      t.boolean :notify_for_new_events, default: true
      t.belongs_to :user
      t.timestamps
    end
  end
end
