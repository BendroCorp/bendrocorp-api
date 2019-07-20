class RpNewsStory < ApplicationRecord
  validates :title, presence: true
  validates :text, presence: true

  validates :created_by_id, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true

  validates :updated_by_id, presence: true
  belongs_to :updated_by, class_name: 'User', foreign_key: 'updated_by_id', optional: true
end
