class ResearchProject < ApplicationRecord
  belongs_to :classification_level

  belongs_to :research_project_status
  belongs_to :research_project_type

  belongs_to :research_project_request
  belongs_to :project_lead, :class_name => 'User', :foreign_key => 'project_lead_id' #project lead has all authority over the project
  belongs_to :created_by, :class_name => 'User', :foreign_key => 'created_by_id'

  belongs_to :classification_level
end
