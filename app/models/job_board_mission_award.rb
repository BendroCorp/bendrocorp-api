class JobBoardMissionAward < ApplicationRecord
  belongs_to :award
  belongs_to :job_board_mission
end
