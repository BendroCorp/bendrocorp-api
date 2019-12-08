class CreateSystemMapSystemSettlements < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_settlements, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :coordinates
      t.boolean :approved, default: true

      t.belongs_to :faction_affiliation
      t.belongs_to :safety_rating, type: :uuid
      t.belongs_to :on_planet, type: :uuid
      t.belongs_to :on_moon, type: :uuid
      t.belongs_to :primary_image, type: :uuid
      t.belongs_to :discovered_by
      t.integer :minimum_criminality_rating

      t.belongs_to :jurisdiction
      t.timestamps
    end
  end
end
