class ReportTemplate < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  has_many :fields, -> { where archived: false }, class_name: 'ReportTemplateField', foreign_key: 'template_id'
  # audited
  validates :handler_id, presence: true
  belongs_to :handler, class_name: 'ReportHandler', foreign_key: 'handler_id', optional: true

  validates :name, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id'

  belongs_to :role, optional: true
end
