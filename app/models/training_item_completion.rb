class TrainingItemCompletion < ApplicationRecord
  validates :item_version, presence: true
  belongs_to :user
  belongs_to :training_item
end
