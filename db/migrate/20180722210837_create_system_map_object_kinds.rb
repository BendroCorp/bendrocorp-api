class CreateSystemMapObjectKinds < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_object_kinds do |t|
      t.text :title
      t.text :class_name
      t.timestamps
    end
  end
end
