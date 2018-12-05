class TrainingCourse < ApplicationRecord
  belongs_to :badge, optional: true
  has_many :training_course_completions
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'
  has_many :training_items, -> { where archived: false }
end
