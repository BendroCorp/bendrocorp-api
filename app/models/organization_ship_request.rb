class OrganizationShipRequest < ApplicationRecord
  belongs_to :user #required field/fk
  belongs_to :owned_ship
  belongs_to :approval #required field/fk

  #other fields
  belongs_to :division

  accepts_nested_attributes_for :approval

  # has_attached_file :procedures_document,
  #                   :path => "/bendrocorp/#{Rails.env}/ship_documents/:id/:filename",
  #                   styles: {thumbnail: "60x60#"}

  # validates_attachment :procedures_document, content_type: { content_type: "application/pdf" }

  def approval_completion
    # required for approval
    # approval actions here
    owned_ship.is_corp_ship = true
    owned_ship.organization_ship_request_id = id
    # create default roles
    owned_ship.crew_roles << OwnedShipCrewRole.new(title: "Commanding Officer", role_slots: 1, ordinal: 1, recruitable: false, editable: false, is_commander:true)
    owned_ship.crew_roles << OwnedShipCrewRole.new(title: "Executive Officer", role_slots: 1, ordinal: 2, recruitable: false, editable: false)
    owned_ship.save

    # add the ship owner to the CO roles
    owned_ship.crew_members << OwnedShipCrew.new(crew_role: self.owned_ship.crew_roles[0], character: self.owned_ship.character ) # self.owned_ship.crew_roles
  end

  def approval_denied
    owned_ship.organization_ship_request_id = nil
    owned_ship.save
  end
end
