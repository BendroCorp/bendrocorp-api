class ProfileGroupSlotRequest < ApplicationRecord
  belongs_to :user
  belongs_to :character
  belongs_to :profile_group_slot
  belongs_to :approval

  accepts_nested_attributes_for :profile_group_slot

  def approval_completion
    # change the status to filled
    profile_group_slot.slot_status_id = '5386404a-484b-4793-ac8c-5a4fadac172c' # set to filled
    profile_group_slot.character_id = self.character_id

    # save the change
    profile_group_slot.save
  end

  def approval_denied
    # remove the character and set the status back to open
    # TODO: May in the end want to check to see what the last status was before pending and set it to that?
    profile_group_slot.slot_status_id = '63d4797d-85b4-41b9-b20c-75cad3b0ecfa' # set to open
    # save the change
    profile_group_slot.save
  end
end
