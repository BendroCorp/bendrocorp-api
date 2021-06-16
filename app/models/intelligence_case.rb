class IntelligenceCaseValidator < ActiveModel::Validator
  def validate(record)
    # another validator handles this condition
    return if record.rsi_handle.nil?

    # try to ping RSI for the handle
    begin
      # ping RSI
      uri = "https://robertsspaceindustries.com/citizens/#{record.rsi_handle}"
      page = HTTParty.get(uri, timeout: 15)

      # send error if page code is invalid
      record.errors[:rsi_handle] << 'is invalid' if page.code != 200
    rescue StandardError => e
      puts e
      record.errors[:rsi_handle] << 'Error occured'
    end
  end
end

class IntelligenceCase < ApplicationRecord
  has_paper_trail

  before_create { rsi_handle.downcase! }

  before_validation { assign_case if assigned_to_id.nil? }

  validates :rsi_handle, presence: true, length: { maximum: 255 },
  uniqueness: { case_sensitive: false }

  validates :case_summary, presence: true
  validates_with IntelligenceCaseValidator

  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id
  belongs_to :classification_level, optional: true
  belongs_to :threat_level, optional: true, class_name: 'FieldDescriptor', foreign_key: :threat_level_id

  # .where.not(approval_status_id: 'a067e0d6-018e-4afc-87c9-6c486c512a76') # temp - just let officers see all reports - even drafts
  has_many :incident_reports, -> { where(archived: false) }, dependent: :delete_all

  has_many :comments, -> { order(created_at: :desc) }, class_name: 'IntelligenceCaseComment', foreign_key: :intelligence_case_id,
  dependent: :delete_all

  has_many :warrants, class_name: 'IntelligenceWarrant', foreign_key: :intelligence_case_id,
  dependent: :delete_all

  belongs_to :assigned_to, class_name: 'User', foreign_key: :assigned_to_id
  belongs_to :assigned_by, class_name: 'User', foreign_key: :assigned_by_id

  def pending_incident_report_count
    # all cases with the pending descriptor id
    incident_reports.where(approval_status_id: 'd593a55f-86fd-4cfa-88ce-1b8e38737c8c').count
  end

  private 
  def assign_case
    # NOTE: The main use case of this method is when a user submits an offender report
    # get all of the security users
    # TODO: May have to decide how we want this to work
    users = Role.find_by_id(5).users
    # get a random user
    selected_user = users[rand(0..(users.count - 1))]

    # assigned by the system user
    self.assigned_by_id = 0

    # assign to the the random selected security member
    puts selected_user.id
    self.assigned_to = selected_user
  end
end
