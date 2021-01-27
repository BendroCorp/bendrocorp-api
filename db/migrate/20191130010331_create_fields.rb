class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields, id: :uuid do |t|
      t.text :name
      t.text :description
      t.boolean :read_only, default: false

      t.belongs_to :field_descriptor_class, type: :uuid

      t.belongs_to :created_by

      t.boolean :archived, default: false

      t.integer :ordinal
      t.text :additional_data

      t.boolean :multi_value_allowed, default: false
      t.timestamps
    end
  end
end
