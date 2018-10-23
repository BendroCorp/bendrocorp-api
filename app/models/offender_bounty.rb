class OffenderBounty < ApplicationRecord
  belongs_to :offender_bounty_approval_request
  belongs_to :offender, :class_name => 'OffenderReportOffender', :foreign_key => 'offender_id'
end
