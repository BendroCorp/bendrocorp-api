class ApplicantApprovalRequest < ApplicationRecord
  validates :user_id, presence: true
  belongs_to :user, optional: true #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :application
end
