class OffenderReportInfractionsCommitted < ApplicationRecord
  belongs_to :infraction, class_name: 'OffenderReportInfraction', foreign_key: 'infraction_id'
  belongs_to :report, class_name: 'OffenderReport', foreign_key: 'report_id', optional: true
end
