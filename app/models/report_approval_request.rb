class ReportApprovalRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :report

  accepts_nested_attributes_for :report

  def approval_completion #what happens when the approval is approved
    # handler code goes here
    
    # self.report.save
  end

  def approval_denied #what happens when the approval is denied
    self.report.draft = true
    self.save
  end
end
