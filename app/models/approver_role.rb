class ApproverRole < ApplicationRecord
  belongs_to :approval_kind
  belongs_to :role
end
