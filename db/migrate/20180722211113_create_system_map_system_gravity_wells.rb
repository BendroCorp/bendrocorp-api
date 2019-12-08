class CreateSystemMapSystemGravityWells < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_gravity_wells, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags
      t.boolean :approved, default: true

      t.belongs_to :system, type: :uuid
      t.belongs_to :gravity_well_type, type: :uuid
      t.belongs_to :luminosity_class, type: :uuid
      t.belongs_to :discovered_by
      t.belongs_to :primary_image
      t.boolean :discovered
      t.boolean :archived, default: false

      t.belongs_to :classification_level, index: false
      t.timestamps
    end
  end
end
