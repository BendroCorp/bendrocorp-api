class CreateSystemMapImages < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_images, id: :uuid do |t|
      t.text :title
      t.text :description
      t.belongs_to :created_by

      t.boolean :is_default_image, default: false

      t.belongs_to :of_system, type: :uuid
      t.belongs_to :of_planet, type: :uuid
      t.belongs_to :of_moon, type: :uuid
      t.belongs_to :of_system_object, type: :uuid
      t.belongs_to :of_location, type: :uuid
      t.belongs_to :of_settlement, type: :uuid
      t.belongs_to :of_gravity_well, type: :uuid
      t.timestamps
    end
  end
end
