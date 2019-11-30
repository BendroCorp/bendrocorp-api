class ReportHandler < ApplicationRecord
  has_many :variables, class_name: 'ReportHandlerVariable', foreign_key: 'handler_id'
end
