class Field < ApplicationRecord
    before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
    has_many :descriptors, class_name: 'FieldDescriptor', foreign_key: 'field_id'
end
