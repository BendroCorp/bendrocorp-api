class CreateDonations < ActiveRecord::Migration[5.1]
  def change
    create_table :donations do |t|
      t.belongs_to :donation_item
      t.belongs_to :user

      t.integer :amount
      t.text :stripe_transaction_id

      t.boolean :charge_succeeded, default: false
      t.boolean :charge_failed, default: false
      t.timestamps
    end
  end
end
