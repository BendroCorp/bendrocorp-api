class CreateOwnedShipCrewRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :owned_ship_crew_roles do |t|
      t.text :title
      t.text :description
      t.integer :role_slots
      t.integer :ordinal
      t.boolean :recruitable
      t.boolean :editable, default: true
      t.boolean :is_commander, default: false
      t.belongs_to :owned_ship
      t.timestamps
    end
  end
end
