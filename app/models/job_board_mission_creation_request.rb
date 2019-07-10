class JobBoardMissionCreationRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :job_board_mission

  accepts_nested_attributes_for :job_board_mission

  def approval_completion #what happens when the approval is approved
    self.job_board_mission.posting_approved = true
    self.job_board_mission.save
  end

  def approval_denied #what happens when the approval is denied
    self.job_board_mission.archived = true
    self.job_board_mission.save
  end
end
