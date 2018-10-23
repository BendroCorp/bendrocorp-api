class CreateTradeCalculationTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_calculation_transactions do |t|
      t.belongs_to :trade_calculation
      t.belongs_to :trade_item
      t.integer :buy_quantity
      t.integer :sell_quantity
      t.belongs_to :trade_item_value_buy, index: false
      t.belongs_to :trade_item_value_sell, index: false
      t.belongs_to :is_finalized
      t.timestamps
    end
    add_index :trade_calculation_transactions, :trade_item_value_buy_id, name: "trade_trans_value_buy_id"
    add_index :trade_calculation_transactions, :trade_item_value_sell_id, name: "trade_trans_value_sell_id"
  end
end
