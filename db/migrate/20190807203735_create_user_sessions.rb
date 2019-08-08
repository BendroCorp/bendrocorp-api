class CreateUserSessions < ActiveRecord::Migration[5.1]
  def change
    create_table :user_sessions, id: :uuid do |t|
      t.belongs_to :user
      t.text :ip_address
      t.float :longitude
      t.float :latitude
      t.text :location
      t.text :country_code
      t.timestamps
    end
  end
end
