class DonationItem < ApplicationRecord
  has_many :donations, -> { where charge_failed: false }
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id'

  def total_donations
    self.donations.sum(:amount)
  end

  def is_completed
    self.total_donations >= self.goal
  end
end
