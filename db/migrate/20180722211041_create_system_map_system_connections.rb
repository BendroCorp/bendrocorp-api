class CreateSystemMapSystemConnections < ActiveRecord::Migration[5.1]
  def change
    create_table :system_map_system_connections, id: :uuid do |t|
      t.text :title
      t.text :description
      t.text :tags
      t.belongs_to :connection_size, type: :uuid, index: false
      t.belongs_to :connection_status, type: :uuid, index: false
      t.belongs_to :system_one, type: :uuid
      t.belongs_to :system_two, type: :uuid

      t.belongs_to :primary_image_one
      t.belongs_to :primary_image_two

      t.belongs_to :classification_level, index: false

      t.belongs_to :discovered_by
      t.boolean :approved, default: true
      t.boolean :archived, default: false
      t.timestamps
    end

    add_index :system_map_system_connections, :connection_size_id, name: "conn_size_id"
    add_index :system_map_system_connections, :connection_status_id, name: "conn_size_status"
  end
end
