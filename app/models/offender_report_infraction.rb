class OffenderReportInfraction < ApplicationRecord
  # has_many :infractions_commited, class_name: 'OffenderReportInfractionsCommitted', foreign_key: 'infraction_id'
  # has_many :offender_reports, through: :infractions_commited, class_name: 'OffenderReport', foreign_key: 'report_id'
  belongs_to :violence_rating, class_name: 'OffenderReportViolenceRating', foreign_key: 'violence_rating_id'
end
