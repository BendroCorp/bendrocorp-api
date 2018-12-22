class ApprovalApprover < ApplicationRecord
  belongs_to :approval
  belongs_to :user
  belongs_to :approval_type
  def approver_response
    if self.approval_type_id == 4
      "Approved"
    elsif self.approval_type_id == 5
      "Denied"
    elsif self.approval_type_id == 6
      "Response un-needed"
    else
      "Pending"
    end
  end

  def character_name
    self.user.main_character.full_name
  end
end
