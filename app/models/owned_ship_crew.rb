class OwnedShipCrew < ApplicationRecord
  belongs_to :owned_ship
  belongs_to :character, :class_name => 'Character', :foreign_key => 'character_id'
  belongs_to :crew_role, :class_name => 'OwnedShipCrewRole', :foreign_key => 'crew_role_id'
end
