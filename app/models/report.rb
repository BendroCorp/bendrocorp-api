class Report < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  has_many :fields, -> { order(:ordinal) }, class_name: 'ReportField', foreign_key: 'report_id'
  accepts_nested_attributes_for :fields

  validates :handler_id, presence: true
  belongs_to :handler, class_name: 'ReportHandler', foreign_key: 'handler_id', optional: true

  validates :template_id, presence: true
  belongs_to :template, class_name: 'ReportTemplate', foreign_key: 'template_id', optional: true

  belongs_to :report_for, class_name: 'ReportRoute', foreign_key: 'report_for_id', optional: true

  validates :user_id, presence: true
  belongs_to :user, optional: true

  belongs_to :approval, optional: true

  # what happens when the approval is approved
  def approval_completion
    self.approved = true
    self.save
  end

  # what happens when the approval is denied
  def approval_denied
    self.draft = true
    self.save
  end
end
