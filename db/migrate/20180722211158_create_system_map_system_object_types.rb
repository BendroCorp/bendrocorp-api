class CreateSystemMapSystemObjectTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_object_types do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
