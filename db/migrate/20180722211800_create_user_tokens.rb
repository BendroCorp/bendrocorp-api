class CreateUserTokens < ActiveRecord::Migration[5.1]
  def change
    create_table :user_tokens do |t|
      t.belongs_to :user
      t.text :token
      t.datetime :expires
      t.text :device
      t.text :ip_address
      t.float :longitude
      t.float :latitude
      t.timestamps
    end
  end
end
