class CreateStoreCarts < ActiveRecord::Migration[5.1]
  def change
    create_table :store_carts do |t|
      t.belongs_to :user
      t.belongs_to :order
      t.timestamps
    end
  end
end
