class Job < ActiveRecord::Base
  has_many :job_trackings
  has_many :characters, through: :job_trackings
  has_many :applications
  belongs_to :division, optional: true
  belongs_to :job_level, optional: true
end
