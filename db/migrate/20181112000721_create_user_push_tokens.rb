class CreateUserPushTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_push_tokens do |t|
      t.belongs_to :user
      t.belongs_to :user_device_type_id
      t.text :token
      t.boolean :active, default: true
      t.timestamps
    end
  end
end
