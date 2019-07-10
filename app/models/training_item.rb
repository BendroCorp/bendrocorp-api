class TrainingItem < ApplicationRecord
  belongs_to :training_course
  belongs_to :training_item_type
  has_many :training_item_completions
  validates :created_by_id, presence: true
  belongs_to :created_by_id, class_name: 'User', foreign_key: 'created_by_id', optional: true

  accepts_nested_attributes_for :training_course

  def user_did_complete user_id
    if self.training_item_completions.where(user_id: user_id, item_version: self.training_course.version).count > 0
      true
    else
      false
    end
  end
end
