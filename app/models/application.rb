class Application < ActiveRecord::Base
  # before_create { self.interview = ApplicationInterview.new if self.interview == nil }

  validates :tell_us_about_the_real_you, presence: true, length: { minimum:1 }
  validates :why_do_want_to_join, presence: true, length: { minimum:1 }
  validates :how_did_you_hear_about_us, presence: true, length: { minimum:1 }
  #validates :job, presence: true

  validates :last_status_changed_by_id, presence: true
  belongs_to :last_status_changed_by, :class_name => 'User', :foreign_key => 'last_status_changed_by_id', optional: true

  belongs_to :job
  belongs_to :application_status
  has_many :comments, :class_name => 'ApplicationComment', :foreign_key => 'application_id'
  belongs_to :character
  has_one :interview, :class_name => 'ApplicationInterview', :foreign_key => 'application_id'

  #has_many :application_approvers
  has_one :applicant_approval_request

  accepts_nested_attributes_for :interview
  accepts_nested_attributes_for :applicant_approval_request
end
