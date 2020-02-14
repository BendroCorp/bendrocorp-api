class ReportApprovalRequest < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  validates :user_id, presence: true
  belongs_to :user, optional: true # required field/fk
  validates :approval_id, presence: true
  belongs_to :approval # required field/fk
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
