class JobBoardMission < ApplicationRecord
  #acceptors JobBoardMissionAcceptor Character
  has_many :acceptors, :class_name => "JobBoardMissionAcceptor", :foreign_key => "job_board_mission_id"
  has_many :characters, through: :acceptors
  accepts_nested_attributes_for :acceptors

  has_many :job_board_mission_awards
  has_many :awards, through: :job_board_mission_awards
  accepts_nested_attributes_for :job_board_mission_awards
  accepts_nested_attributes_for :awards

  validates :created_by_id, presence: true
  belongs_to :created_by, :class_name => "User", :foreign_key => "created_by_id", optional: true #user
  validates :updated_by_id, presence: true
  belongs_to :updated_by, :class_name => "User", :foreign_key => "updated_by_id", optional: true #user #user

  belongs_to :completion_criteria, :class_name => "JobBoardMissionCompletionCriterium", :foreign_key => "completion_criteria_id"
  belongs_to :completion_request, :class_name => "JobBoardMissionCompletionRequest", :foreign_key => "completion_request_id", optional: true
  accepts_nested_attributes_for :completion_request

  belongs_to :creation_request, :class_name => "JobBoardMissionCreationRequest", :foreign_key => "creation_request_id", optional: true
  accepts_nested_attributes_for :creation_request
  belongs_to :mission_status, :class_name => "JobBoardMissionStatus", :foreign_key => "mission_status_id"

  belongs_to :system, :class_name => 'SystemMapSystem', :foreign_key => 'system_id', optional: true
  belongs_to :moon, :class_name => 'SystemMapSystemPlanetaryBodyMoon', :foreign_key => 'moon_id', optional: true
  belongs_to :planet, :class_name => 'SystemMapSystemPlanetaryBody', :foreign_key => 'planet_id', optional: true
  belongs_to :system_object, :class_name => 'SystemMapSystemObject', :foreign_key => 'system_object_id', optional: true
  belongs_to :settlement, :class_name => 'SystemMapSystemSettlement', :foreign_key => 'settlement_id', optional: true
  belongs_to :location, :class_name => 'SystemMapSystemPlanetaryBodyLocation', :foreign_key => 'location_id', optional: true

  def on_mission
    self.characters
  end

  def url_title_string
    "#{self.title.downcase.gsub(' ', '-')}-#{self.id}"
  end

  def created_time_ms
    self.created_at.to_f * 1000
  end
end
