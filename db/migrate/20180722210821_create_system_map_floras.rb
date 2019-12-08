class CreateSystemMapFloras < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_floras, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags

      t.boolean :is_predator
      t.boolean :is_toxic
      t.boolean :is_sentient
      t.integer :density, :limit => 10 #how common is it

      t.belongs_to :on_moon, type: :uuid
      t.belongs_to :on_planet, type: :uuid
      t.belongs_to :on_system_object, type: :uuid
      t.belongs_to :discovered_by
      t.belongs_to :primary_image, type: :uuid

      t.belongs_to :classification_level, index: false

      t.boolean :approved, default: true
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
