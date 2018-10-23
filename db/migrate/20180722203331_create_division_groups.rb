class CreateDivisionGroups < ActiveRecord::Migration[5.1]
  def change
    create_table :division_groups do |t|
      t.text :title
      t.text :description
      t.integer :ordinal

      t.belongs_to :division
      t.timestamps
    end
  end
end
