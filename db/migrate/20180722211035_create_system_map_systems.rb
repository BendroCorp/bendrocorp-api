class CreateSystemMapSystems < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_systems do |t|
      t.text :title
      t.text :description
      t.boolean :approved, default: true

      t.belongs_to :discovered_by
      t.belongs_to :faction_affiliation
      t.boolean :discovered
      t.boolean :archived
      t.belongs_to :jurisdiction
      t.timestamps
    end
  end
end
