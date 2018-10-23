class CreateCharacters < ActiveRecord::Migration[5.1]
  def change
    create_table :characters do |t|
      t.text :first_name
      t.text :last_name
      t.text :nickname
      t.text :description
      t.text :background
      t.belongs_to :job
      t.belongs_to :user
      t.belongs_to :gender
      t.belongs_to :species
      t.boolean :is_main_character, default: false
      t.timestamps
    end
  end
end
