class CreateSystemMapSystemSafetyRatings < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_safety_ratings do |t|
      t.text :title
      t.text :description
      t.string :color
      t.timestamps
    end
  end
end
