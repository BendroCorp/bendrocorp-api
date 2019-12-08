class CreateSystemMapSystemPlanetaryBodyTypeIns < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_planetary_body_type_ins, id: :uuid do |t|
      t.belongs_to :planet, index: false, type: :uuid
      t.belongs_to :planet_type, index: false
      t.timestamps
    end
    add_index :system_map_system_planetary_body_moon_type_ins, :moon_id, name: "planet_id"
    add_index :system_map_system_planetary_body_moon_type_ins, :moon_type_id, name: "planet_type_id"
  end
end
