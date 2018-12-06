class TrainingCourseCompletion < ApplicationRecord
  validates :version, presence: true
  belongs_to :user
  belongs_to :training_course
end
