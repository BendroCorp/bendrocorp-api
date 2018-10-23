class CreateSystemMapSystemPlanetaryBodyMoonTypeIns < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_planetary_body_moon_type_ins do |t|
      t.belongs_to :moon, index: false
      t.belongs_to :moon_type, index: false
      t.timestamps
    end
    add_index :system_map_system_planetary_body_moon_type_ins, :moon_id, name: "moon_id"
    add_index :system_map_system_planetary_body_moon_type_ins, :moon_type_id, name: "moon_type_id"
  end
end
