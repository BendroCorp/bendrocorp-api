class ClassificationRequest < ApplicationRecord
  belongs_to :user #required field/fk
  belongs_to :approval #required field/fk
  belongs_to :classification_request_type
end
