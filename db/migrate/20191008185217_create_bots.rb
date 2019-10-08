class CreateBots < ActiveRecord::Migration[5.1]
  def change
    create_table :bots, id: :uuid do |t|
      t.text :bot_name
      t.text :token
      t.timestamps
    end
  end
end
