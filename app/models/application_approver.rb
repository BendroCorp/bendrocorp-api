class ApplicationApprover < ApplicationRecord
  belongs_to :application
  belongs_to :user
  belongs_to :approval_type

  def approver_response
    if approval_type_id == 4
      "Approved"
    end

    if approval_type_id == 5
      "Denied"
    end
  end
end
