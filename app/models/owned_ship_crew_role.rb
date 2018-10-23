class OwnedShipCrewRole < ApplicationRecord
  belongs_to :owned_ship
  has_many :crew_members, :dependent => :delete_all, :class_name => "OwnedShipCrew", :foreign_key => "crew_role_id"

  def full_name
    "#{self.title} (BCS #{self.owned_ship.title})"
  end

  def recruitable?
    self.crew_members.count < self.role_slots
  end
end
