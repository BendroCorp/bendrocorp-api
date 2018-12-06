class TrainingCourseCompletion < ApplicationRecord
  validates :item_version, presence: true
  belongs_to :user
  belongs_to :training_course
end
