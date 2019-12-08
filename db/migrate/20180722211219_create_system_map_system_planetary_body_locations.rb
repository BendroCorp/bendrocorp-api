class CreateSystemMapSystemPlanetaryBodyLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_planetary_body_locations, id: :uuid do |t|
      t.text :title
      t.text :description
      t.boolean :approved, default: true

      t.text :coordinates #we will probably only get this
      t.float :long #hopefully we get this
      t.float :lat #and this

      t.belongs_to :location_type, index: false
      t.belongs_to :on_moon, index: false, type: :uuid
      t.belongs_to :on_planet, index: false, type: :uuid
      t.belongs_to :on_system_object, index: false, type: :uuid
      t.belongs_to :on_settlement, index: false, type: :uuid
      t.belongs_to :faction_affiliation, index: false
      t.integer :minimum_criminality_rating

      t.belongs_to :discovered_by, index: false
      t.belongs_to :primary_image, index: false, type: :uuid
      t.boolean :discovered
      t.boolean :archived
      t.timestamps
    end
    add_index :system_map_system_planetary_body_locations, :location_type_id, name: "location_type_id"
    add_index :system_map_system_planetary_body_locations, :on_moon_id, name: "on_moon_id"
    add_index :system_map_system_planetary_body_locations, :on_planet_id, name: "on_planet_id"
    add_index :system_map_system_planetary_body_locations, :on_system_object_id, name: "on_system_object_in_id"
    add_index :system_map_system_planetary_body_locations, :discovered_by_id, name: "location_discovered_by_id"
    add_index :system_map_system_planetary_body_locations, :faction_affiliation_id, name: "location_faction_id"
    add_index :system_map_system_planetary_body_locations, :primary_image_id, name: "location_primary_image"

  end
end
