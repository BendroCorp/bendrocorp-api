class CreateTradeItems < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_items do |t|
      t.text :title
      t.text :description
      t.boolean :resellable
      t.decimal :unit_to_ccu
      t.integer :item_size
      t.decimal :average_sell_price, :precision => 10, :scale => 2
      t.decimal :average_buy_price, :precision => 10, :scale => 2

      t.belongs_to :trade_item_container
      t.belongs_to :best_sell_value
      t.belongs_to :worst_sell_value
      t.belongs_to :best_buy_value
      t.belongs_to :worst_buy_value

      t.belongs_to :trade_item_type

      t.boolean :is_ignored, default: false
      t.belongs_to :added_by
      t.timestamps
    end
  end
end
