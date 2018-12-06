class TrainingCourseAssigned < ApplicationRecord
  belongs_to :user
  belongs_to :training_course
  belongs_to :assigned_by, class_name: 'User', foreign_key: 'assigned_by_id'
end
