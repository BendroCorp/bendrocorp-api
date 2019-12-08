class CreateSystemMapSystemPlanetaryBodies < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_planetary_bodies, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags
      t.belongs_to :orbits_system, index: false, id: :uuid
      t.belongs_to :discovered_by
      t.belongs_to :faction_affiliation, type: :uuid, index: false
      t.belongs_to :safety_rating
      t.boolean :discovered
      t.boolean :archived, default: false
      t.boolean :approved, default: true

      #standard known characteristics
      t.boolean :atmosphere_present #dep
      t.boolean :atmosphere_human_breathable #dep
      t.integer :atmospheric_height
      t.float :atmo_pressure #in ATL
      t.boolean :surface_hazards
      t.float :tempature_max
      t.float :tempature_min
      t.float :solar_day
      t.float :population_density
      t.float :economic_rating
      t.float :general_radiation
      t.integer :minimum_criminality_rating

      # orbital characteristics - currently just a stub may never be used
      t.text :semi_major_axis
      t.text :apoapsis
      t.text :periapsis
      t.text :orbital_eccentricity
      t.text :orbital_inclination
      t.text :argument_of_periapsis
      t.text :longitude_of_the_ascending_node
      t.text :mean_anomaly
      t.text :sidereal_orbital_period
      t.text :synodic_orbital_period
      t.text :orbital_velocity

      # physical characteristics - may not be used
      t.text :surface_gravity
      t.text :escape_velocity
      t.text :mass

      t.belongs_to :jurisdiction, index: false
      t.belongs_to :classification_level, index: false

      t.belongs_to :primary_image, index: false, id: :uuid
      t.timestamps
    end
    add_index :system_map_system_planetary_bodies, :jurisdiction_id, name: "planet_juristiction_id"
    add_index :system_map_system_planetary_bodies, :orbits_system_id, name: "orbits_system_id"
    add_index :system_map_system_planetary_bodies, :faction_affiliation_id, name: "planet_faction_id"
    add_index :system_map_system_planetary_bodies, :primary_image_id, name: "planet_primary_image"
  end
end
