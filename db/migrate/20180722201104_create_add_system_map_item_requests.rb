class CreateAddSystemMapItemRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :add_system_map_item_requests do |t|
      t.belongs_to :system_map_object_kind, index: false
      t.integer :kind_pk

      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.timestamps
    end
  end
end
