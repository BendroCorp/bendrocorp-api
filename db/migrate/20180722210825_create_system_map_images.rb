class CreateSystemMapImages < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_images do |t|
      t.text :title
      t.text :description
      t.belongs_to :created_by

      t.boolean :is_default_image, default: false

      t.belongs_to :of_system
      t.belongs_to :of_planet
      t.belongs_to :of_moon
      t.belongs_to :of_system_object
      t.belongs_to :of_location
      t.belongs_to :of_settlement
      t.belongs_to :of_gravity_well
      t.timestamps
    end
  end
end
