class CreateResearchProjectTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :research_project_tasks do |t|
      t.text :title

      t.belongs_to :task_status
      t.belongs_to :task_type
      t.belongs_to :research_project
      t.belongs_to :created_by

      t.boolean :is_archived
      t.timestamps
    end
  end
end
