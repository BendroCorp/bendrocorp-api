class CreateOwnedShipCrews < ActiveRecord::Migration[5.1]
  def change
    create_table :owned_ship_crews do |t|
      t.belongs_to :owned_ship
      t.belongs_to :crew_role
      t.belongs_to :character

      t.boolean :request_approved, default: false
      t.boolean :is_backup_crew, default: false
      t.timestamps
    end
  end
end
