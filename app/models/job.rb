class Job < ActiveRecord::Base
  validates :title, presence: true
  validates :description, presence: true

  has_many :job_trackings
  has_many :characters, through: :job_trackings
  has_many :applications
  belongs_to :division, optional: true
  belongs_to :job_level, optional: true
  belongs_to :checks_max_headcount_from, class_name: 'Job', foreign_key: 'checks_max_headcount_from_id', optional: true

  def max_hired
    if self.checks_max_headcount_from
      return true if self.checks_max_headcount_from.max && self.checks_max_headcount_from.max != -1 && self.checks_max_headcount_from.characters.count >= self.checks_max_headcount_from.max
    else
      return true if self.max && self.max != -1 && self.characters.count >= self.max
    end
    return false
  end
end
