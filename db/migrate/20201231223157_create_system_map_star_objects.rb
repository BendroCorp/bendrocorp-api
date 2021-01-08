class CreateSystemMapStarObjects < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_star_objects, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags
      t.text :primary_image_id
      t.belongs_to :object_type, type: :uuid
      t.belongs_to :parent, type: :uuid
      t.boolean :draft, default: true
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
