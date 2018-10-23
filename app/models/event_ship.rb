class EventShip < ApplicationRecord
  belongs_to :event
  belongs_to :owned_ship
end
