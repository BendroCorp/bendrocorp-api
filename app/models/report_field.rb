class ReportField < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  # after_create :create_value, if: Proc.new { |report_field| report_field.field_value.nil? }

  validates :report_id, presence: true
  belongs_to :report, class_name: 'Report', foreign_key: 'report_id', optional: true

  has_one :field_value, class_name: 'ReportFieldValue', foreign_key: 'report_id'
  accepts_nested_attributes_for :field_value

  belongs_to :field, optional: true

  belongs_to :report_handler_variable, optional: true

  # validators
  validates :name, presence: true
  validates :field_presentation_type_id, presence: true
  validates :ordinal, presence: true

  private def create_value
    self.field_value = ReportFieldValue.new(report_id: report_id, field_id: id)
    self.save
  end
end
