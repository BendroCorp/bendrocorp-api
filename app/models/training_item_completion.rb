class TrainingItemCompletion < ApplicationRecord
  validates :version, presence: true
  belongs_to :user
  belongs_to :training_item
end
