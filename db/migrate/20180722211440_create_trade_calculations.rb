class CreateTradeCalculations < ActiveRecord::Migration[5.1]
  def change
    create_table :trade_calculations do |t|
      t.belongs_to :from_system #dep ?
      t.belongs_to :to_system #dep ?
      t.belongs_to :owned_ship

      t.belongs_to :safety_rating #system_map_system_safety_rating
      t.belongs_to :classification_level

      t.belongs_to :user

      t.boolean :is_finalized, default: false
      t.timestamps
    end
  end
end
