class ApplicantApprovalRequest < ApplicationRecord
  belongs_to :user #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :application
end
