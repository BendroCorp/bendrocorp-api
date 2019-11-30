class FieldDescriptor < ApplicationRecord
    before_create { self.id = SecureRandom.uuid if self.id == nil && ENV["RAILS_ENV"] != 'production' }
    belongs_to :field, class_name: 'Field', foreign_key: 'field_id'
end
