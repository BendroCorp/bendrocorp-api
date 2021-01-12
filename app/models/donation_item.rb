class DonationItem < ApplicationRecord
  has_many :donations, -> { where charge_failed: false }
  validates :created_by_id, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true

  validates :donation_type_id, presence: true
  belongs_to :donation_type, class_name: 'FieldDescriptor', foreign_key: :donation_type_id, optional: true

  def total_donations
    self.donations.sum(:amount)
  end

  def is_completed
    self.total_donations >= self.goal
  end
end
