class CreateStoreOrderStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :store_order_statuses do |t|
      t.text :title
      t.text :description
      t.boolean :can_select, default: true
      t.timestamps
    end
  end
end
