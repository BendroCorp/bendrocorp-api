class CreateTradeItemValues < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_item_values do |t|
      t.decimal :buy_price
      t.decimal :sell_price

      t.belongs_to :location
      t.belongs_to :trade_item

      t.belongs_to :added_by

      t.boolean :is_ignored, default: false
      t.boolean :is_finalized
      t.timestamps
    end
  end
end
