class CreateSystemMapSystems < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_systems, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags
      t.boolean :approved, default: true

      t.belongs_to :discovered_by
      t.belongs_to :faction_affiliation, type: :uuid
      t.boolean :discovered
      t.boolean :archived, default: false
      t.belongs_to :jurisdiction
      t.belongs_to :classification_level, index: false

      t.belongs_to :primary_image, type: :uuid
      t.timestamps
    end
  end
end
