class CreateOwnedShips < ActiveRecord::Migration[5.1]
  def change
    create_table :owned_ships do |t|
      t.text :title
      t.belongs_to :avatar
      t.belongs_to :character
      t.belongs_to :ship #once selected this can't be changed
      t.belongs_to :organization_ship_request
      t.decimal :fcr, default:0 #fuel consumption rate - units of fuel burned per AU traveled
      t.boolean :is_corp_ship, default: false
      t.boolean :hidden, default: false #soft delete
      t.timestamps
    end
  end
end
