class CreateFieldDescriptorClasses < ActiveRecord::Migration[5.1]
  def change
    create_table :field_descriptor_classes, id: :uuid do |t|
      t.text :title
      t.text :class_name # identifies the class
      t.text :class_field # identifies the attribute or method to draw
      t.boolean :restrict_by_owner, default: false
      t.text :owner_field_name # id. created_by_id, etc.
      t.boolean :archived, default: false
      t.timestamps
    end
  end
end
