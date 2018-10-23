class CreateSystemMapAtmoCompositions < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_atmo_compositions do |t|
      t.belongs_to :atmo_gas
      t.belongs_to :for_planet
      t.belongs_to :for_moon
      t.belongs_to :for_system_object
      t.decimal :percentage
      t.timestamps
    end
  end
end
