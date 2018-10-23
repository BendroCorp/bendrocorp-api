class JobBoardMissionStatus < ApplicationRecord
  has_many :missions, :class_name => "JobBoardMission", :foreign_key => "mission_status_id"
end
