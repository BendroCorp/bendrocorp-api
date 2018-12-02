class Donation < ApplicationRecord
  validates :amount, presence: true, length: { minimum:3, maximum: 70 }
  belongs_to :donation_item
  belongs_to :user
end
