class CreateResearchProjectRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :research_project_requests do |t|
      t.belongs_to :research_project
      t.belongs_to :approval
      t.belongs_to :user
      t.timestamps
    end
  end
end
