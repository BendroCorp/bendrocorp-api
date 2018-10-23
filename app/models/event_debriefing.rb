class EventDebriefing < ApplicationRecord
  # validates :event_id, presence: true
  belongs_to :event, optional: true
end
