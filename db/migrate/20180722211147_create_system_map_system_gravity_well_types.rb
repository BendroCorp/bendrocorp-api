class CreateSystemMapSystemGravityWellTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_gravity_well_types do |t|
      t.string :title
      t.string :well_type
      t.string :color
      t.string :approx_surface_temperature
      t.text :main_characteristics
      t.timestamps
    end
  end
end
