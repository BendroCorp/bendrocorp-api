class CreateStoreItems < ActiveRecord::Migration[5.1]
  def change
    create_table :store_items do |t|
      # Title, Description, Image, Cost, Currency Type, Quantity Available, Size [If applicable]
      t.text :title
      t.text :description
      t.decimal :cost, :precision => 8, :scale => 2
      t.belongs_to :currency_type
      t.belongs_to :category
      t.integer :base_stock # the amount of items in stock
      t.string :size
      t.boolean :archived, default: false
      t.boolean :show_in_store, default: false
      t.boolean :locked, default: false

      t.decimal :max_shipping_cost, :precision => 8, :scale => 2
      t.integer :weight # in ounces

      t.belongs_to :creator
      t.belongs_to :last_updated_by
      t.timestamps
    end
  end
end
