class CreateStoreOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :store_orders do |t|
      t.belongs_to :cart
      t.belongs_to :status
      t.text :stripe_transaction_id
      t.text :stripe_refund_id
      t.belongs_to :point_transaction
      t.boolean :payment_processed
      t.boolean :refund_issued, default: false
      t.text :tracking_number
      t.decimal :added_shipping_cost, :precision => 8, :scale => 2

      t.belongs_to :assigned_to
      t.belongs_to :last_updated_by
      t.timestamps
    end
  end
end
