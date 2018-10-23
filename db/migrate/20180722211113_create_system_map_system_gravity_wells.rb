class CreateSystemMapSystemGravityWells < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_gravity_wells do |t|
      t.text :title
      t.text :description
      t.boolean :approved, default: true

      t.belongs_to :system
      t.belongs_to :gravity_well_type
      t.belongs_to :luminosity_class
      t.belongs_to :discovered_by
      t.belongs_to :primary_image
      t.boolean :discovered
      t.boolean :archived
      t.timestamps
    end
  end
end
