class CreateOwnedShipCrewRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :owned_ship_crew_requests do |t|
      t.belongs_to :crew
      t.belongs_to :approval
      t.belongs_to :user
      t.timestamps
    end
  end
end
