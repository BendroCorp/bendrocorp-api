class ReportHandlerValidator < ActiveModel::Validator
  def validate(record)
    if !record.for_class.nil? && record.approval_kind_id.nil?
      record.errors[:for_role_id] << 'You must specify an approval kind if a handler is for a class!'
    end
  end
end

class ReportHandler < ApplicationRecord
  # validations
  validates :name, presence: true

  belongs_to :approval_kind, optional: true

  has_many :variables, class_name: 'ReportHandlerVariable', foreign_key: 'handler_id'

  validates_with ReportHandlerValidator
end
