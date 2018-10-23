class EventAward < ApplicationRecord
  belongs_to :event
  belongs_to :award
end
