class CreateResearchProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :research_projects do |t|
      t.text :title
      t.text :description
      t.text :tags #comma(space?) seperated single word list

      t.belongs_to :system
      t.belongs_to :planet
      t.belongs_to :moon
      t.belongs_to :system_object
      t.belongs_to :location

      t.belongs_to :research_project_status
      t.belongs_to :research_project_type

      t.belongs_to :research_project_request
      t.belongs_to :project_lead #project lead has all authority over the project
      t.belongs_to :created_by

      t.belongs_to :classification_level

      t.boolean :is_archived
      t.timestamps
    end
  end
end
