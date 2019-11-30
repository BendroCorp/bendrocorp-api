class Report < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  has_many :fields, class_name: 'ReportField', foreign_key: 'report_id'
  accepts_nested_attributes_for :fields

  validates :handler_id, presence: true
  belongs_to :handler, class_name: 'ReportHandler', foreign_key: 'handler_id', optional: true

  validates :template_id, presence: true
  belongs_to :template, class_name: 'ReportTemplate', foreign_key: 'template_id', optional: true

  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :report_for, class_name: 'User', foreign_key: 'report_for_id', optional: true
end
