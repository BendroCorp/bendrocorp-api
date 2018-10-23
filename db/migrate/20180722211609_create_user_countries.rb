class CreateUserCountries < ActiveRecord::Migration[5.1]
  def change
    create_table :user_countries do |t|
      t.text :code
      t.text :title
      t.timestamps
    end
  end
end
