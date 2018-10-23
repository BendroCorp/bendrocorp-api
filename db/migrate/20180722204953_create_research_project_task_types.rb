class CreateResearchProjectTaskTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :research_project_task_types do |t|
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
