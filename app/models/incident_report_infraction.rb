class IncidentReportInfraction < ApplicationRecord
  has_paper_trail

  belongs_to :incident_report
  belongs_to :infraction, class_name: 'FieldDescriptor', foreign_key: 'infraction_id'
end
