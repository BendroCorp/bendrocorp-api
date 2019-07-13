class TrainingItemCompletion < ApplicationRecord
  validates :item_version, presence: true
  validates :user_id, presence: true
  belongs_to :user, optional: true
  belongs_to :training_item
end
