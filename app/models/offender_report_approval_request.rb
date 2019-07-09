class OffenderReportApprovalRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :offender_report #required - request owner
  belongs_to :approval #required field/fk

  def approval_completion #required function for request approval - it calls this
    self.offender_report.report_approved = true;
    if self.offender_report.save
      #TODO
    else
      #TODO
    end
  end

  def approval_denied #required function for request approval - it calls this
    self.offender_report.report_approved = false;
    self.offender_report.submitted_for_approval = false;
    if self.offender_report.save
      #TODO
    else
      #TODO
    end
  end
end
