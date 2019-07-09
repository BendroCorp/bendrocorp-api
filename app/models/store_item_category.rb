class StoreItemCategory < ApplicationRecord
  # NOTE: THIS IS REALLY IMPORTANT
  has_many :items, -> { where archived: false }, :class_name => 'StoreItem', :foreign_key => 'category_id'

  validates :creator_id, presence: true
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id', optional: true
  belongs_to :last_updated_by, :class_name => 'User', :foreign_key => 'last_updated_by_id'
end
