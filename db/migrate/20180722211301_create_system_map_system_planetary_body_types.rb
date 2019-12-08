class CreateSystemMapSystemPlanetaryBodyTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_planetary_body_types, id: :uuid do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
