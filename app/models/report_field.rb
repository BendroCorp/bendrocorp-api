class ReportField < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  before_create { self.field_value = ReportFieldValue.new(report_id: self.report_id, field_id: self.id) }

  validates :report_id, presence: true
  belongs_to :report, class_name: 'Report', foreign_key: 'report_id', optional: true

  has_one :field_value, class_name: 'ReportFieldValue', foreign_key: 'report_id'
  accepts_nested_attributes_for :field_value

  belongs_to :field, optional: true

  # validators
  validates :name, presence: true
  validates :field_presentation_type_id, presence: true
  validates :ordinal, presence: true
end
