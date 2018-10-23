class CreateSystemMapFaunas < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_faunas do |t|
      t.text :title
      t.text :description

      t.boolean :is_predator
      t.boolean :is_sentient
      t.integer :density, :limit => 10 #how common is it

      t.belongs_to :on_moon
      t.belongs_to :on_planet
      t.belongs_to :on_system_object
      t.belongs_to :discovered_by
      t.belongs_to :primary_image

      t.boolean :approved, default: true
      t.timestamps
    end
  end
end
