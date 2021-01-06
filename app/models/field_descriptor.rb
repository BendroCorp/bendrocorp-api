class FieldDescriptor < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }

  validates :field_id, presence: true
  belongs_to :field, class_name: 'Field', foreign_key: 'field_id', optional: true

  # validates :created_by_id, presence: true
  belongs_to :created_by, class_name: 'User', foreign_key: 'created_by_id', optional: true

  has_many :field_descriptor_field_maps
  has_many :fields, through: :field_descriptor_field_maps
end
