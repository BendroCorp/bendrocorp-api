class JobTracking < ActiveRecord::Base
  belongs_to :character
  belongs_to :job
end
