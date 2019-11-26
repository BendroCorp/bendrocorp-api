class CreateFieldDescriptors < ActiveRecord::Migration[5.1]
  def change
    create_table :field_descriptors, id: :uuid do |t|
      t.belongs_to :field, type: :uuid
      t.text :title
      t.text :description
      t.text :ordinal
      t.timestamps
    end
  end
end
