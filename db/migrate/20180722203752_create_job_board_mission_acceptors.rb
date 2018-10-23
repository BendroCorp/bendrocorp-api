class CreateJobBoardMissionAcceptors < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_mission_acceptors do |t|
      t.belongs_to :job_board_mission
      t.belongs_to :character
      t.timestamps
    end
  end
end
