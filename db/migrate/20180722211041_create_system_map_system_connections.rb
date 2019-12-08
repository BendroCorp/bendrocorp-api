class CreateSystemMapSystemConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_connections, id: :uuid do |t|
      t.belongs_to :system_map_system_connection_size, index: false
      t.belongs_to :system_map_system_connection_status, index: false
      t.belongs_to :system_one, type: :uuid
      t.belongs_to :system_two, type: :uuid

      t.belongs_to :discovered_by
      t.boolean :discovered
      t.boolean :archived
      t.boolean :collapsed
      t.timestamps
    end

    add_index :system_map_system_connections, :system_map_system_connection_size_id, name: "conn_size_id"
    add_index :system_map_system_connections, :system_map_system_connection_status_id, name: "conn_size_status"
  end
end
