class ProfileGroupSlot < ApplicationRecord
  belongs_to :profile_group
  belongs_to :character
  belongs_to :role
end
