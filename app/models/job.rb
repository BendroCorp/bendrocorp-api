class Job < ActiveRecord::Base
  has_many :job_trackings
  has_many :characters, through: :job_trackings
  has_many :applications
  belongs_to :division
  belongs_to :job_level
end
