class SystemMapMappingRule < ApplicationRecord
  before_create { self.id = SecureRandom.uuid if self.id == nil && ENV['RAILS_ENV'] != 'production' }

  validates :parent_id, presence: true
  validates :child_id, presence: true

  belongs_to :parent, optional: true
  belongs_to :child, optional: true
end
