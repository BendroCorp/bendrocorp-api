class CreateEventShips < ActiveRecord::Migration[5.1]
  def change
    create_table :event_ships do |t|
      t.belongs_to :event
      t.belongs_to :owned_ship
      t.timestamps
    end
  end
end
