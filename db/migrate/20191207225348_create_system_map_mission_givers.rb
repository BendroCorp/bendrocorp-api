class CreateSystemMapMissionGivers < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_mission_givers, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags

      t.belongs_to :discovered_by
      t.belongs_to :primary_image, type: :uuid

      t.belongs_to :classification_level

      t.belongs_to :faction_affiliation, type: :uuid

      t.belongs_to :on_system_object, type: :uuid
      t.belongs_to :on_settlement, type: :uuid
      t.belongs_to :on_location, type: :uuid

      t.boolean :approved, default: true
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
