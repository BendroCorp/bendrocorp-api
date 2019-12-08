class CreateSystemMapSystemObjects < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_objects, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags
      t.boolean :approved, default: true

      t.belongs_to :object_type, type: :uuid

      t.belongs_to :orbits_system, type: :uuid
      t.belongs_to :orbits_planet, type: :uuid
      t.belongs_to :orbits_moon, type: :uuid

      t.belongs_to :discovered_by
      t.boolean :discovered

      t.boolean :archived, default: false

      # standard known characteristics
      t.boolean :atmosphere_present
      t.boolean :atmosphere_human_breathable
      t.float :atmo_pressure # in ATL
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

      t.belongs_to :jurisdiction
      t.belongs_to :faction_affiliation, type: :uuid

      t.belongs_to :classification_level, index: false

      t.belongs_to :primary_image, type: :uuid
      t.timestamps
    end
  end
end
