class ProfileGroupSlot < ApplicationRecord
  has_paper_trail

  belongs_to :profile_group
  belongs_to :character
  belongs_to :slot_status
  belongs_to :role
end
