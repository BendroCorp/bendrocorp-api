class Donation < ApplicationRecord
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 1 }
  belongs_to :donation_item
  belongs_to :user
end
