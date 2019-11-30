class ReportHandlerVariable < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  belongs_to :handler, class_name: 'ReportHandler', foreign_key: 'handler_id'
end
