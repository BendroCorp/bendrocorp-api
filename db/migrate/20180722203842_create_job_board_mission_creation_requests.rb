class CreateJobBoardMissionCreationRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_mission_creation_requests do |t|
      t.belongs_to :user #required field/fk
      t.belongs_to :approval #required field/fk
      t.belongs_to :job_board_mission, index: false
      t.timestamps
    end
    add_index :job_board_mission_creation_requests, :job_board_mission_id, name: "creation_req_mission_id"
  end
end
