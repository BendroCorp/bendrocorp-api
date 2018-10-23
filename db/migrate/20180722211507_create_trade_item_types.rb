class CreateTradeItemTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_item_types do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
