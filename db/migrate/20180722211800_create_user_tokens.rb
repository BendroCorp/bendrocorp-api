class CreateUserTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tokens do |t|
      t.belongs_to :user
      t.text :token
      t.datetime :expires
      t.timestamps
    end
  end
end
