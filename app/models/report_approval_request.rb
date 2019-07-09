class ReportApprovalRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :report

  accepts_nested_attributes_for :report

  def approval_completion #what happens when the approval is approved
    self.report.report_status_type_id = 4
    self.report.returned = false
    self.report.approved = true
    self.save
  end

  def approval_denied #what happens when the approval is denied
    self.report.report_status_type_id = 3
    self.report.submitted = false
    self.report.returned = true
    self.save
  end
end
