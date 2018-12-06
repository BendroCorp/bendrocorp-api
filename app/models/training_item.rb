class TrainingItem < ApplicationRecord
  belongs_to :training_course
  belongs_to :training_item_type
  has_many :training_item_completions
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  accepts_nested_attributes_for :training_course

  def user_did_complete user
    if self.training_item_completions.where(user: user, item_version: self.training_course.version).count > 0
      true
    else
      false
    end
  end
end
