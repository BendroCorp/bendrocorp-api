class TrainingCourse < ApplicationRecord
  validates :version, presence: true

  belongs_to :badge, optional: true
  has_many :training_course_completions
  validates :created_by_id, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true
  has_many :training_items, -> { where archived: false }
  has_many :assigned_users, class_name: 'TrainingCourseAssigned', foreign_key: 'training_course_id'
end
