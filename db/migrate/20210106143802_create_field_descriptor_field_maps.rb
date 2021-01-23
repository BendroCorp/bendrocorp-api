class CreateFieldDescriptorFieldMaps < ActiveRecord::Migration[5.1]
  def change
    create_table :field_descriptor_field_maps, id: :uuid do |t|
      t.belongs_to :field_descriptor
      t.belongs_to :field
      t.integer :ordinal
      t.timestamps
    end
  end
end
