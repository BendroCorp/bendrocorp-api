class Chat < ApplicationRecord
  validates :user_id, presence: true
  validates :text, presence: true
  belongs_to :user, optional: true
end
