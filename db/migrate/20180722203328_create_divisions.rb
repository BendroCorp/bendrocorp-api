class CreateDivisions < ActiveRecord::Migration[5.1]
  def change
    create_table :divisions do |t|
      t.text :name
      t.text :color
      t.text :font_color
      t.text :short_name
      t.text :description
      t.boolean :can_have_ships, default: true
      t.integer :ordinal
      t.timestamps
    end
  end
end
