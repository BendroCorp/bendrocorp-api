class CreateClassificationLevels < ActiveRecord::Migration[5.1]
  def change
    create_table :classification_levels do |t|
      t.text :title
      t.text :description
      t.string :color
      t.integer :ordinal
      t.boolean :compartmentalized, default: false
      t.boolean :hidden, default: false
      t.timestamps
    end
  end
end
