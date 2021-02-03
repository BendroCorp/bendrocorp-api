class Alert < ApplicationRecord
  has_paper_trail # auditing changes

  validates :title, presence: true
  validates :description, presence: true

  belongs_to :star_object, class_name: 'SystemMapStarObject', foreign_key: :star_object_id, optional: true

  validates :user_id, presence: true
  belongs_to :user, optional: true
  belongs_to :approval, optional: true
end
