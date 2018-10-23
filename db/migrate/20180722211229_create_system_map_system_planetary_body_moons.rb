class CreateSystemMapSystemPlanetaryBodyMoons < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_planetary_body_moons do |t|
      t.text :title
      t.text :description
      t.belongs_to :orbits_planet, index: false
      t.belongs_to :discovered_by, index: false
      t.belongs_to :faction_affiliation, index: false
      t.boolean :discovered
      t.boolean :archived
      t.boolean :approved, default: true

      #standard known characteristics
      t.boolean :atmosphere_present
      t.boolean :atmosphere_human_breathable
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

      # orbital characteristics - currently just a stub may never be universalSystemUpdate
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

      #physical characteristics - may not be used
      t.text :surface_gravity
      t.text :escape_velocity
      t.text :mass

      t.belongs_to :primary_image, index: false
      t.timestamps
    end
    add_index :system_map_system_planetary_body_moons, :orbits_planet_id, name: "orbits_planet_id"
    add_index :system_map_system_planetary_body_moons, :discovered_by_id, name: "moon_discovered_by_id"
    add_index :system_map_system_planetary_body_moons, :primary_image_id, name: "moon_primary_image"
  end
end
