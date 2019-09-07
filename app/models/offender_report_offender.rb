class OffenderReportOffender < ApplicationRecord
  before_save { self.offender_name.downcase! if self.offender_name }

  validates :offender_handle, presence: true, length: { maximum: 255 }, uniqueness: { case_sensitive: false }
  validates :offender_name, length: { maximum: 255 }

  has_many :offender_reports, -> { where report_approved: true, archived: false }, :class_name => 'OffenderReport', :foreign_key => 'offender_id'
  has_many :bounties, :class_name => 'OffenderBounty', :foreign_key => 'offender_id'

  belongs_to :offender_rating, :class_name => 'OffenderReportViolenceRating', :foreign_key => 'offender_rating_id', optional: true
  belongs_to :offender_report_org, optional: true

  def full_location
    self.offender_reports.last.full_location
  end
end
