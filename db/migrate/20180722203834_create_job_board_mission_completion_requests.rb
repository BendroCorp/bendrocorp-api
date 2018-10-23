class CreateJobBoardMissionCompletionRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_mission_completion_requests do |t|
      # standard fields
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :job_board_mission, index: false

      # special fields
      #t.belongs_to :creation_request
      t.belongs_to :child_approval, index: false #check to see if child approval is approved before allowing this to go through
      t.belongs_to :flight_log, index: false
      t.text :completion_message
      t.timestamps
    end
    add_index :job_board_mission_completion_requests, :job_board_mission_id, name: "completion_req_mission_id"
    add_index :job_board_mission_completion_requests, :child_approval_id, name: "completion_req_child_approval_id"

  end
end
