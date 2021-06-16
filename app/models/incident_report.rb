NOT_STARTED_GUID = 'a067e0d6-018e-4afc-87c9-6c486c512a76'
PENDING_GUID = 'd593a55f-86fd-4cfa-88ce-1b8e38737c8c'
APPROVED_GUID = 'f4619ce3-2d7e-41cd-9286-7f889e8f17b6'
DECLINED_GUID = 'd9bbda83-e290-4b0c-88ff-1e15ab674640'

class IncidentReportValidator < ActiveModel::Validator
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

class IncidentReportSubmissionValidator < ActiveModel::Validator
  def validate(record)
    # another validator handles this condition
    if record.approval_status_id.nil? || record.approval_status_id != PENDING_GUID
      return
    end

    record.errors[:description] << 'You must enter a description' if description.nil?
    record.errors[:occured_when] << 'You must enter a when' if occured_when.nil?
    record.errors[:star_object_id] << 'You must enter where the incident happened' if star_object_id.nil?
    record.errors[:force_used_id] << 'You must enter the amount of force used by you' if force_used_id.nil?
    record.errors[:infractions] << 'You must add at least one infraction' if incident_report_infractions.count == 0
  end
end

class IncidentReport < ApplicationRecord
  has_paper_trail

  before_create { rsi_handle.downcase! }
  after_create { UpdateIntelCaseHandleAvatarJob.perform_later(self) }

  # validations
  validates :rsi_handle, presence: true
  before_validation :check_for_handle_case_or_create
  validates :intelligence_case_id, presence: true
  validates_with IncidentReportValidator

  # relations
  belongs_to :intelligence_case, optional: true
  belongs_to :star_object, class_name: 'SystemMapStarObject', foreign_key: :star_object_id, optional: true
  belongs_to :force_used, class_name: 'FieldDescriptor', foreign_key: :force_used_id, optional: true
  belongs_to :ship_used, class_name: 'Ship', foreign_key: :ship_used_id, optional: true
  belongs_to :violence_rating, class_name: 'FieldDescriptor', foreign_key: :violence_rating_id, optional: true
  belongs_to :created_by, class_name: 'User', foreign_key: :created_by_id

  belongs_to :approval_status, class_name: 'FieldDescriptor', foreign_key: :approval_status_id, optional: true

  has_many :incident_report_infractions
  has_many :infractions, through: :incident_report_infractions, class_name: 'FieldDescriptor', foreign_key: :infraction_id

  has_many :comments, -> { order(created_at: :desc) }, class_name: 'IncidentReportComment', foreign_key: :incident_report_id,
  dependent: :delete_all

  def assigned_to_full_name
    intelligence_case.assigned_to.main_character_full_name
  end

  def assigned_to_id
    intelligence_case.assigned_to_id
  end

  private
  def check_for_handle_case_or_create
    # see if a case exists for the handle
    intel_case = IntelligenceCase.find_by(rsi_handle: self.rsi_handle)

    # null/assing check
    if intel_case
      self.intelligence_case_id = intel_case.id
    else
      is_security = User.find_by_id(self.created_by_id).is_in_role(54)
      if is_security
        new_case = IntelligenceCase.create(rsi_handle: self.rsi_handle, case_summary: 'Auto generated from incident report. Please see your report when available and update.', created_by_id: self.created_by_id, assigned_to_id: self.created_by_id)
        self.intelligence_case = new_case
      else
        new_case = IntelligenceCase.create(rsi_handle: self.rsi_handle, case_summary: 'Auto generated from incident report. Please see report when available and update.', created_by_id: 0)
        self.intelligence_case = new_case
      end
    end
  end
end
