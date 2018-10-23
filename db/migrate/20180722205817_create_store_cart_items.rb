class CreateStoreCartItems < ActiveRecord::Migration[5.1]
  def change
    create_table :store_cart_items do |t|
      t.belongs_to :cart
      t.belongs_to :item
      t.integer :quantity
      t.timestamps
    end
  end
end
