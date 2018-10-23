class CreateJobBoardMissionStatuses < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_mission_statuses do |t|
      t.text :title
      t.text :description
      # 1 - Open, 2 - Success, 3 - Failed
      t.timestamps
    end
  end
end
