class ReportFieldValue < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  validates :report_id, presence: true
  belongs_to :report, class_name: 'Report', foreign_key: 'report_id', optional: true
  validates :field_id, presence: true
  belongs_to :field, class_name: 'ReportField', foreign_key: 'field_id', optional: true

  # validates :value, presence: true
end