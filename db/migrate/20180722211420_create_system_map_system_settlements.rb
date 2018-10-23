class CreateSystemMapSystemSettlements < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_settlements do |t|
      t.text :title
      t.text :description
      t.text :coordinates
      t.boolean :approved, default: true

      t.belongs_to :faction_affiliation
      t.belongs_to :safety_rating
      t.belongs_to :on_planet
      t.belongs_to :on_moon
      t.belongs_to :primary_image
      t.integer :minimum_criminality_rating
      t.timestamps
    end
  end
end
