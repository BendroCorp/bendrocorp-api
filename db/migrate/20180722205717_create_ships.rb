class CreateShips < ActiveRecord::Migration[5.1]
  def change
    create_table :ships do |t|
      t.text :name
      t.text :manufacturer
      t.integer :size #1 = Small, 2 = Medium, 3 = Large
      t.integer :cargo_capacity, default: 0
      t.integer :crew_size, default: 1
      t.boolean :selectable, default: true
      t.timestamps
    end
  end
end
