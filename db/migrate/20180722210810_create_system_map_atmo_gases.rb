class CreateSystemMapAtmoGases < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_atmo_gases do |t|
      t.text :title
      t.text :description
      t.boolean :toxic
      t.timestamps
    end
  end
end
