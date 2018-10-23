class CreateSystemMapSystemGravityWellLuminosityClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_gravity_well_luminosity_classes do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
