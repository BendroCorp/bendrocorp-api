class CreateResearchProjectTaskAssignees < ActiveRecord::Migration[5.1]
  def change
    create_table :research_project_task_assignees do |t|
      t.belongs_to :user
      t.timestamps
    end
  end
end
