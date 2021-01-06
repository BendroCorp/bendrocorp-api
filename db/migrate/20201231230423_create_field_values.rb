class CreateFieldValues < ActiveRecord::Migration[5.1]
  def change
    create_table :field_values, id: :uuid do |t|
      t.belongs_to :field, type: :uuid
      t.text :value
      t.belongs_to :master, type: :uuid
      t.timestamps
    end
  end
end
