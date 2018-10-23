class CreatePointTransactions < ActiveRecord::Migration[5.1]
  def change
    create_table :point_transactions do |t|
      t.integer :amount
      t.text :reason
      t.boolean :approved
      t.references :user
      t.timestamps
    end
  end
end
