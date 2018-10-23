class CreateSystemMapSystemConnectionSizes < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_connection_sizes do |t|
      t.string :size
      t.string :size_short
      t.text :description
      t.timestamps
    end
  end
end
