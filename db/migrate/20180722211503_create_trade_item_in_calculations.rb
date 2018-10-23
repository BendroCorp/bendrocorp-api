class CreateTradeItemInCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_item_in_calculations do |t|
      t.belongs_to :trade_item
      t.belongs_to :trade_calculation
      t.timestamps
    end
  end
end
