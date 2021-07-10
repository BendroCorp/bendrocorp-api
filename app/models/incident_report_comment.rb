class IncidentReportComment < ApplicationRecord

  # validations
  validates :comment, presence: true
  validates :incident_report_id, presence: true

  # other objects
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :incident_report
end
