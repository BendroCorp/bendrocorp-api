class EventAutoAttendance < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
  belongs_to :event
  belongs_to :user
end
