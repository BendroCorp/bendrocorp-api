class CreateSystemMapSystemConnectionTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_connection_types do |t|

      t.timestamps
    end
  end
end
