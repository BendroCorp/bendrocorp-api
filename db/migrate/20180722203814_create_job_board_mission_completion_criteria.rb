class CreateJobBoardMissionCompletionCriteria < ActiveRecord::Migration[5.1]
  def change
    create_table :job_board_mission_completion_criteria do |t|
      t.text :title
      t.text :description
      # (Kinds: Escort, Bounty, Catalogue, Recovery, Other (See Description))
      t.boolean :flight_log_required, default: false
      t.boolean :child_approval_required, default: false
      t.belongs_to :child_approval_request_type, index: false #approval_kind
      t.timestamps
    end
  end
end
