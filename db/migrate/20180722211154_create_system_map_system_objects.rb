class CreateSystemMapSystemObjects < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_objects do |t|
      t.text :title
      t.text :description
      t.boolean :approved, default: true

      t.belongs_to :object_type

      t.belongs_to :orbits_system
      t.belongs_to :orbits_planet
      t.belongs_to :orbits_moon

      t.belongs_to :discovered_by
      t.boolean :discovered

      t.boolean :archived

      #standard known characteristics
      t.boolean :atmosphere_present
      t.boolean :atmosphere_human_breathable
      t.float :atmo_pressure #in ATL
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

      t.belongs_to :primary_image
      t.timestamps
    end
  end
end
