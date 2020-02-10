class ReportReportValidator < ActiveModel::Validator
  def validate(record)
    if !record.for_role_id.nil? && !record.for_user_id.nil?
      record.errors[:for_role_id] << 'Both for_user_id and for_role_id cannot be present at the same time!'
      record.errors[:for_user_id] << 'Both for_user_id and for_role_id cannot be present at the same time!'
    end

    if record.for_role_id.nil? && record.for_user_id.nil?
      record.errors[:for_role_id] << 'You must include either for_user_id or for_role_id!'
      record.errors[:for_user_id] << 'You must include either for_user_id or for_role_id!'
    end
  end
end

class ReportRoute < ApplicationRecord
  validates :title, presence: true
  validates_with ReportReportValidator
end
