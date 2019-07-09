class JobBoardMissionCompletionRequest < ApplicationRecord
  validates :flight_log_id, presence: true

  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :job_board_mission

  belongs_to :flight_log

  def approval_completion #what happens when the approval is approved

    # if a flight log is involved set it to public so the images can be viewed
    # and disallow privacy changes so it can be changed back to private
    if self.flight_log != nil
      self.flight_log.public = true
      self.flight_log.privacy_changes_allowed = false
    end

    self.job_board_mission.mission_status_id = 3 #change the status to completed

    #create positive transaction for acceptors
    self.job_board_mission.acceptors.each do |acceptor|
      PointTransaction.create(user_id: acceptor.character.user_id, amount: self.job_board_mission.op_value, reason: "Completed mission: #{self.job_board_mission.title}.")
    end
    self.job_board_mission.save

    # take op points away from the requester
    if self.job_board_mission.creation_request != nil # this should be nil if its spawned from a system map addition request or offender report or whatever...
      if self.job_board_mission.creation_request.user_id != 0 # aka its not the system user - though we shouldn't hit this
        # create a negative transaction for the requester
        PointTransaction.create(user_id: self.job_board_mission.creation_request.user_id, amount: -(self.job_board_mission.op_value * self.acceptors.count), reason: "Completed mission: #{self.job_board_mission.title} which you created.")
      end
    end
  end

  def approval_denied #what happens when the approval is denied
    self.job_board_mission.mission_status_id = 4 #change the status of the job to failed
  end
end
