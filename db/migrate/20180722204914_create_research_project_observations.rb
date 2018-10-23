class CreateResearchProjectObservations < ActiveRecord::Migration[5.1]
  def change
    create_table :research_project_observations do |t|
      t.text :title
      t.text :text

      t.references :research_project_task, index: false
      t.references :research_project
      t.references :created_by
      t.timestamps
    end
    add_index :research_project_observations, :research_project_task_id, name: "ob_to_project_task_id"
  end
end
