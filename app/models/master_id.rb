class MasterId < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV['RAILS_ENV'] != 'production' }

  # NOTE: Fields 'fields' can be fetched as an attribute of 'type' (ie. self.type.fields)

  has_many :field_values, class_name: 'FieldValue', foreign_key: 'master_id'
  accepts_nested_attributes_for :field_values

  # allows a field descriptor to identify an object as a type
  validates :type_id, presence: true
  belongs_to :type, class_name: 'FieldDescriptor', foreign_key: :type_id, optional: true

  belongs_to :update_role, class_name: 'Role', foreign_key: :update_role_id, optional: true
end
