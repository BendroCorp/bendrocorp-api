class ReportHandlerVariable < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  validates :handler_id, presence: true
  belongs_to :handler, class_name: 'ReportHandler', foreign_key: 'handler_id', optional: true
end
