class OwnedShipCrewRequest < ApplicationRecord
  belongs_to :crew, :class_name => 'OwnedShipCrewRole', :foreign_key => 'crew_id'
  belongs_to :approval
  belongs_to :user

  def approval_completion #required for approval
    # self.owned_ship.crew_members << OwnedShipCrew.new(crew_role: self.owned_ship.crew_roles[0], character: self.owned_ship.character ) # self.owned_ship.crew_roles
    # self.crew.request_approved = true
    # self.crew.save
    @owned_ship = self.crew.owned_ship
    @owned_ship.crew_members << OwnedShipCrew.new(crew_role: self.crew, character: self.user.main_character)
  end

  def approval_denied
      #do nothing (nothing needs to be done here)
  end
end
