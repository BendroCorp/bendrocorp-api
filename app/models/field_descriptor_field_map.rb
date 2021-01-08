class FieldDescriptorFieldMap < ApplicationRecord
  belongs_to :field_descriptor
  belongs_to :field
end
