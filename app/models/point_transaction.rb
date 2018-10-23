class PointTransaction < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :amount, presence: true
  validates :reason, presence: true
end
