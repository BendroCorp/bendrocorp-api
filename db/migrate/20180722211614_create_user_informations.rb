class CreateUserInformations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_informations do |t|
      t.text :first_name
      t.text :last_name
      t.text :street_address
      t.text :city
      t.text :state
      t.text :zip
      t.belongs_to :country

      t.belongs_to :user
      t.timestamps
    end
  end
end
