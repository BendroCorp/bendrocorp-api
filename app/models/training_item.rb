class TrainingItem < ApplicationRecord
  belongs_to :training_course
  belongs_to :training_item_type
  has_many :training_item_completions
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  def user_did_complete user
    self.training_item_completions.each do |completion|
      true if completion.user.id == user.id 
    end
    false
  end
end
