class MasterId < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV['RAILS_ENV'] != 'production' }

  has_many :field_values
  accepts_nested_attributes_for :field_values

  # allows a field descriptor to identify an object as a type
  validates :type_id, presence: true
  belongs_to :type, class_name: 'FieldDescriptor', foreign_key: :type_id, optional: true

  # fields
  has_many :field_descriptor_field_maps
  has_many :fields, -> { order 'field_descriptor_field_maps.ordinal' }, though: :field_descriptor_field_maps

  belongs_to :update_role, class_name: 'Role', foreign_key: :update_role_id, optional: true
end
