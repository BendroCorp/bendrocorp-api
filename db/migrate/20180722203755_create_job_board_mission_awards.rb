class CreateJobBoardMissionAwards < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_mission_awards do |t|
      t.belongs_to :award
      t.belongs_to :job_board_mission
      t.timestamps
    end
  end
end
