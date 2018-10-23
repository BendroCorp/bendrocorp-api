class CreateTradeItemContainers < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_item_containers do |t|
      t.text :title
      t.text :description

      t.decimal :scu
      t.decimal :width
      t.decimal :height
      t.decimal :depth
      t.timestamps
    end
  end
end
