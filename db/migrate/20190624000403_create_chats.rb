class CreateChats < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.text :text
      t.boolean :edited
      t.belongs_to :chat_room
      t.belongs_to :user
      t.timestamps
    end
  end
end
