class Attendence < ActiveRecord::Base
  belongs_to :event
	belongs_to :character
  belongs_to :attendence_type
  belongs_to :user
end
