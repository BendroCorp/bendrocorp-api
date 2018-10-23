class Report < ApplicationRecord
  belongs_to :submitter, :class_name => 'User', :foreign_key => 'submitter_id'
  belongs_to :specified_submit_to_role, :class_name => 'Role', :foreign_key => 'specified_submit_to_role_id'
  belongs_to :report_type
  belongs_to :flight_log
  belongs_to :report_approval_request
  belongs_to :report_status_type

  accepts_nested_attributes_for :report_approval_request

  def url_title_string
    "#{self.title.downcase.gsub(' ', '-')}-#{self.id}"
  end

  def report_time_ms
    self.created_at.to_f * 1000
  end
end
