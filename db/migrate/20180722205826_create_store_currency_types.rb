class CreateStoreCurrencyTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :store_currency_types do |t|
      t.text :title
      t.text :description
      t.string :currency_symbol
      t.timestamps
    end
  end
end
