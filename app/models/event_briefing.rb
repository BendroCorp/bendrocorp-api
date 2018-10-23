class EventBriefing < ApplicationRecord
  # validates :event_id, presence: true
  belongs_to :event

  belongs_to :operational_leader, :class_name => 'Character', :foreign_key => 'operational_leader_id', optional: true
  belongs_to :reporting_designee, :class_name => 'Character', :foreign_key => 'reporting_designee_id', optional: true
  belongs_to :communications_designee, :class_name => 'Character', :foreign_key => 'communications_designee_id', optional: true
  belongs_to :escort_leader, :class_name => 'Character', :foreign_key => 'escort_leader_id', optional: true

  belongs_to :starting_system, :class_name => 'SystemMapSystem', :foreign_key => 'starting_system_id', optional: true
  belongs_to :ending_system, :class_name => 'SystemMapSystem', :foreign_key => 'ending_system_id', optional: true
end
